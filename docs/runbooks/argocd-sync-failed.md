# Runbook: ArgoCD Sync Failed

**Symptom:** ArgoCD app shows `OutOfSync` or `SyncFailed`.

## Investigate

```bash
# Check app status
argocd app get <app-name>

# Check sync operation log
argocd app sync <app-name> --dry-run

# Check Kubernetes events in app namespace
kubectl get events -n <namespace> --sort-by='.lastTimestamp' | tail -20
```

## Common Causes

| Error | Cause | Fix |
|---|---|---|
| `admission webhook denied` | OPA/Kyverno policy violation | Check which policy failed; fix manifest |
| `resource already exists` | Helm release conflict | `helm uninstall` and let ArgoCD re-sync |
| `ImagePullBackOff` | Image not found or registry blocked | Check image tag exists and registry is in allowed list |
| `insufficient cpu/memory` | ResourceQuota exceeded | Increase quota via Crossplane Namespace claim |

## Force sync
```bash
argocd app sync <app-name> --force
```
