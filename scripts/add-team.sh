#!/usr/bin/env bash
# Onboard a new team to the IDP — provisions namespace, RBAC, and catalog entry
# Usage: ./scripts/add-team.sh --team payments --environment staging

set -euo pipefail
TEAM=${1:-myteam}
ENV=${2:-staging}

echo "Onboarding team: $TEAM | environment: $ENV"

cat <<EOF | kubectl apply -f -
apiVersion: platform.company.io/v1alpha1
kind: Namespace
metadata:
  name: ${TEAM}-namespace-claim
spec:
  parameters:
    team: ${TEAM}
    environment: ${ENV}
    resourceQuota:
      cpu: "4"
      memory: "8Gi"
EOF

echo "Namespace claim submitted. Watch progress:"
echo "  kubectl get namespace.platform.company.io ${TEAM}-namespace-claim"
