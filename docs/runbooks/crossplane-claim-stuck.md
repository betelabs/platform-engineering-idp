# Runbook: Crossplane Claim Stuck / Not Ready

**Symptom:** A Crossplane claim has been in `Waiting` or `Creating` state for > 15 minutes.

## Investigate

```bash
# Check the claim status
kubectl describe postgres.platform.company.io <claim-name> -n <namespace>

# Check the composite resource
kubectl get xpostgres -A

# Check Crossplane provider logs
kubectl logs -l pkg.crossplane.io/revision=provider-aws -n crossplane-system --tail=50

# Check for AWS errors
kubectl describe dbinstance -A | grep -A5 'Message:'
```

## Common Causes

| Symptom | Cause | Fix |
|---|---|---|
| `InvalidParameterCombination` | Instance class not available in AZ | Change `instanceClass` or `region` |
| `AccessDenied` | IRSA role missing permission | Check IAM role attached to Crossplane SA |
| `QuotaExceeded` | AWS service quota hit | Request quota increase in AWS console |
| Composition not found | Label selector mismatch | Check `compositionSelector` labels match a Composition |

## Escalation
If unresolved in 30 minutes → `#platform-support` Slack.
