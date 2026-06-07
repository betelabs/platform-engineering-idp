#!/usr/bin/env bash
# Bootstrap the full IDP platform on a fresh cluster
# Usage: ./scripts/bootstrap.sh --env dev --cloud aws

set -euo pipefail
ENV=${1:-dev}
CLOUD=${2:-aws}

echo "=========================================="
echo "  Platform Engineering IDP Bootstrap"
echo "  Environment : $ENV"
echo "  Cloud       : $CLOUD"
echo "=========================================="

# 1. ArgoCD
echo "[1/6] Installing ArgoCD..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s
echo "      ArgoCD ready ✓"

# 2. Crossplane
echo "[2/6] Installing Crossplane..."
helm upgrade --install crossplane crossplane-stable/crossplane \
  --namespace crossplane-system --create-namespace \
  --set args[0]=--debug
kubectl wait --for=condition=available deployment/crossplane -n crossplane-system --timeout=180s
kubectl apply -f crossplane/providers/
echo "      Crossplane ready ✓"

# 3. OPA Gatekeeper
echo "[3/6] Installing OPA Gatekeeper..."
helm upgrade --install gatekeeper gatekeeper/gatekeeper \
  --namespace gatekeeper-system --create-namespace
kubectl apply -f policies/opa/
echo "      OPA Gatekeeper ready ✓"

# 4. Kyverno
echo "[4/6] Installing Kyverno..."
helm upgrade --install kyverno kyverno/kyverno \
  --namespace kyverno --create-namespace
kubectl apply -f policies/kyverno/
echo "      Kyverno ready ✓"

# 5. Backstage
echo "[5/6] Deploying Backstage..."
helm upgrade --install backstage ./helm/idp-platform \
  --namespace backstage --create-namespace \
  -f helm/idp-platform/values.yaml
echo "      Backstage ready ✓"

# 6. Bootstrap ArgoCD apps
echo "[6/6] Bootstrapping ArgoCD ApplicationSets..."
kubectl apply -f gitops/argocd/projects/
kubectl apply -f gitops/argocd/appsets/

echo ""
echo "=========================================="
echo "  Bootstrap complete!"
echo ""
echo "  ArgoCD UI:   kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "  Backstage:   kubectl port-forward svc/backstage -n backstage 3000:80"
echo "=========================================="
