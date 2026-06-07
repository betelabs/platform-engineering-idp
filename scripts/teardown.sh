#!/usr/bin/env bash
# Tear down the IDP — use only in dev/test environments
set -euo pipefail

read -p "Are you sure you want to tear down the platform? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

kubectl delete -f gitops/argocd/appsets/ --ignore-not-found
kubectl delete -f gitops/argocd/projects/ --ignore-not-found
helm uninstall backstage      -n backstage        2>/dev/null || true
helm uninstall crossplane     -n crossplane-system 2>/dev/null || true
helm uninstall gatekeeper     -n gatekeeper-system 2>/dev/null || true
helm uninstall kyverno        -n kyverno           2>/dev/null || true
kubectl delete namespace argocd backstage crossplane-system gatekeeper-system kyverno --ignore-not-found
echo "Teardown complete."
