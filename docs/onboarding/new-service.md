# Creating Your First Service

## Via Backstage (recommended)

1. Open the Backstage portal
2. Click **Create** in the top nav
3. Choose **New Microservice** template
4. Fill in the form — takes about 2 minutes
5. Click **Create** — the platform provisions everything automatically

**What gets created:**
- GitHub repo with your chosen language skeleton
- `catalog-info.yaml` registered in Backstage
- GitHub Actions CI pipeline (build → scan → push)
- ArgoCD Application targeting your team namespace
- Kubernetes namespace (via Crossplane claim)
- Database (if requested, via Crossplane claim)

## Via kubectl (advanced)

If you prefer to work directly:

```bash
# 1. Create your namespace
kubectl apply -f - <<EOF
apiVersion: platform.company.io/v1alpha1
kind: Namespace
metadata:
  name: my-service-ns-claim
spec:
  parameters:
    team: my-team
    environment: staging
EOF

# 2. Create a database
kubectl apply -f crossplane/claims/examples/claim-postgres.yaml -n team-my-team

# 3. Deploy your app using the golden-path Helm chart
helm upgrade --install my-service ./helm/app-template \
  --namespace team-my-team \
  --set image.repository=ghcr.io/my-org/my-service \
  --set image.tag=v1.0.0 \
  --set labels.team=my-team \
  --set labels.env=staging
```
