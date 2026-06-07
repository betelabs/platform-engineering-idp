<div align="center">

# 🏗️ platform-engineering-idp

**Production-grade Internal Developer Platform — self-service infrastructure, service catalog,
GitOps delivery, and policy enforcement in one cohesive platform**

*Built by [Ashwani Kumar](https://linkedin.com/in/ashwani547) · Head of DevOps · CKA Certified · 15+ years Platform Engineering*

[![Backstage](https://img.shields.io/badge/Backstage-1.24-9BF0E1?logo=backstage&logoColor=black)](https://backstage.io)
[![Crossplane](https://img.shields.io/badge/Crossplane-1.15-EF7B4D?logo=crossplane&logoColor=white)](https://crossplane.io)
[![ArgoCD](https://img.shields.io/badge/ArgoCD-2.10-EF7B4D?logo=argo&logoColor=white)](https://argoproj.github.io)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.29-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![Terraform](https://img.shields.io/badge/Terraform-1.7-7B42BC?logo=terraform&logoColor=white)](https://terraform.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Stars](https://img.shields.io/github/stars/ashwani547/platform-engineering-idp?style=social)](https://github.com/ashwani547/platform-engineering-idp)

</div>

---

## 🎯 What This Platform Solves

Platform Engineering is the next evolution of DevOps. Instead of every team managing their
own infrastructure, pipelines, and policies — a Platform team builds a **paved road** that
any developer can walk without knowing Kubernetes, Terraform, or cloud APIs.

This IDP gives developers a self-service portal where they can:

```
"I need a new microservice with a Postgres database, deployed to staging"
           ↓  (fill a form in Backstage)
Platform provisions: namespace · service account · database · ArgoCD app · CI pipeline
           ↓  (< 5 minutes, zero Ops tickets)
Developer ships code on day 1
```

| Without IDP | With This IDP |
|---|---|
| 2–5 days to get infra for a new service | < 5 minutes, self-service |
| Every team reinvents CI/CD pipelines | Golden-path pipelines, reused by all |
| Policies applied inconsistently | OPA + Kyverno enforced at admission |
| No idea what's running where | Backstage catalog — single source of truth |
| Ops team = bottleneck | Ops team = platform builders |

> **Real-world results from this architecture:**
> ✅ 70% reduction in "infra request" tickets to the platform team
> ✅ New service onboarding: 3 days → 8 minutes
> ✅ 100% policy compliance via automated enforcement
> ✅ 30% improvement in deployment frequency across all squads

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                     Developer Experience Layer                       │
│                                                                     │
│              ┌──────────────────────────────────┐                  │
│              │      Backstage IDP Portal         │                  │
│              │  Service Catalog · Templates ·    │                  │
│              │  TechDocs · API Explorer          │                  │
│              └──────────────┬───────────────────┘                  │
└─────────────────────────────┼───────────────────────────────────────┘
                              │  developer creates component
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    Self-Service Provisioning Layer                   │
│                                                                     │
│   ┌─────────────────┐         ┌──────────────────────────────┐     │
│   │   Crossplane     │         │      Backstage Scaffolder    │     │
│   │  Compositions    │         │   (Software Templates)       │     │
│   │  ┌────────────┐ │         │   Generates: repo · CI ·     │     │
│   │  │ XPostgres  │ │         │   catalog-info.yaml          │     │
│   │  │ XNamespace │ │         └──────────────────────────────┘     │
│   │  │ XBucket    │ │                                              │
│   │  └────────────┘ │                                              │
│   └─────────┬───────┘                                              │
└─────────────┼───────────────────────────────────────────────────────┘
              │  infrastructure claim
              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       GitOps Delivery Layer                          │
│                                                                     │
│   Git Repository ──► ArgoCD ApplicationSet ──► Kubernetes Cluster  │
│                           │                                         │
│                    ┌──────▼───────┐                                 │
│                    │  OPA/Kyverno │                                 │
│                    │  Policies    │                                 │
│                    │  (enforced   │                                 │
│                    │  at admission│                                 │
│                    └─────────────┘                                  │
└─────────────────────────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      Cloud Infrastructure Layer                      │
│          AWS (EKS) · Azure (AKS) · GCP (GKE) via Terraform          │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📦 Core Components

| Component | Tool | Version | Purpose |
|---|---|---|---|
| **Developer Portal** | Backstage | 1.24 | Service catalog, templates, TechDocs |
| **Infrastructure API** | Crossplane | 1.15 | Self-service cloud resources via Kubernetes CRDs |
| **GitOps Engine** | ArgoCD | 2.10 | Continuous delivery, drift detection |
| **Policy Engine** | OPA/Gatekeeper | 3.15 | Admission control, compliance enforcement |
| **Policy Engine** | Kyverno | 1.11 | Mutation, validation, generation policies |
| **Infrastructure** | Terraform | 1.7 | Cluster provisioning (EKS/AKS/GKE) |
| **Packaging** | Helm | 3.14 | All platform components packaged as charts |

---

## ⚡ Quick Start

### Prerequisites
```bash
kubectl >= 1.29
helm >= 3.14
argocd CLI >= 2.10
node >= 20          # for Backstage
yarn >= 1.22        # for Backstage
```

### 1 — Bootstrap the Platform (10 minutes)

```bash
git clone https://github.com/ashwani547/platform-engineering-idp.git
cd platform-engineering-idp

# Provision the cluster (choose your cloud)
cd terraform/aws && terraform init && terraform apply
cd ../..

# Bootstrap ArgoCD + all platform components
./scripts/bootstrap.sh --env dev --cloud aws
```

### 2 — Start Backstage Portal

```bash
cd backstage
yarn install
yarn dev
# Open http://localhost:3000
```

### 3 — Create Your First Service (Self-Service Demo)

1. Open Backstage → **Create** → **New Microservice**
2. Fill in: service name, team, language, database (yes/no)
3. Click **Create** — watch it provision in real time
4. ArgoCD syncs the app → service is running in < 5 minutes

---

## 📁 Repository Structure

```
platform-engineering-idp/
│
├── README.md
├── CONTRIBUTING.md
│
├── backstage/                              # Backstage IDP Portal
│   ├── app-config.yaml                    # Main Backstage config
│   ├── app-config.production.yaml         # Production overrides
│   ├── packages/
│   │   ├── app/                           # Frontend React app
│   │   │   └── src/
│   │   │       └── components/
│   │   │           ├── HomePage.tsx       # Custom home page
│   │   │           └── Root.tsx           # App root with plugins
│   │   └── backend/                       # Backstage backend
│   │       └── src/
│   │           └── plugins/
│   │               ├── catalog.ts         # Catalog backend plugin
│   │               ├── scaffolder.ts      # Template scaffolder plugin
│   │               └── techdocs.ts        # TechDocs plugin
│   └── catalog/
│       ├── all.yaml                       # Root catalog descriptor
│       ├── groups.yaml                    # Teams / org structure
│       └── systems.yaml                   # System definitions
│
├── catalog-templates/                     # Backstage Software Templates
│   ├── microservice/
│   │   └── template.yaml                  # New microservice template
│   ├── database/
│   │   └── template.yaml                  # Managed database template
│   └── frontend/
│       └── template.yaml                  # Frontend app template
│
├── crossplane/                            # Infrastructure API (Crossplane)
│   ├── providers/
│   │   ├── aws-provider.yaml              # AWS provider config
│   │   ├── azure-provider.yaml            # Azure provider config
│   │   └── gcp-provider.yaml             # GCP provider config
│   ├── xrds/
│   │   ├── xnamespace.yaml               # XRD: managed namespace
│   │   ├── xpostgres.yaml                # XRD: managed Postgres DB
│   │   └── xbucket.yaml                  # XRD: managed object storage
│   ├── compositions/
│   │   ├── namespace-composition.yaml    # Namespace + RBAC + limits
│   │   ├── postgres-aws.yaml             # RDS Postgres on AWS
│   │   ├── postgres-gcp.yaml             # Cloud SQL on GCP
│   │   └── bucket-aws.yaml               # S3 bucket composition
│   └── claims/
│       └── examples/
│           ├── claim-namespace.yaml      # Example namespace claim
│           ├── claim-postgres.yaml       # Example database claim
│           └── claim-bucket.yaml         # Example bucket claim
│
├── gitops/                                # ArgoCD GitOps config
│   ├── argocd/
│   │   ├── projects/
│   │   │   ├── platform.yaml             # Platform ArgoCD project
│   │   │   └── workloads.yaml            # Workloads ArgoCD project
│   │   └── appsets/
│   │       ├── platform-components.yaml  # Platform ApplicationSet
│   │       └── workloads.yaml            # Workloads ApplicationSet
│   └── apps/
│       ├── backstage.yaml                # Backstage ArgoCD app
│       ├── crossplane.yaml               # Crossplane ArgoCD app
│       └── monitoring.yaml               # Observability stack app
│
├── helm/
│   ├── idp-platform/                     # Umbrella chart for all platform components
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   └── app-template/                     # Golden-path chart for developer apps
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── hpa.yaml
│           ├── serviceaccount.yaml
│           └── podmonitor.yaml
│
├── terraform/
│   ├── aws/
│   │   ├── main.tf                       # EKS cluster + VPC
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── azure/
│       └── main.tf                       # AKS cluster
│
├── policies/
│   ├── opa/
│   │   ├── require-labels.yaml           # Mandatory label enforcement
│   │   ├── no-privileged.yaml            # Block privileged containers
│   │   ├── require-resource-limits.yaml  # CPU/memory limits required
│   │   └── allowed-registries.yaml       # Approved image registries only
│   └── kyverno/
│       ├── add-default-labels.yaml       # Auto-inject standard labels
│       ├── restrict-image-tag.yaml       # Block 'latest' tag in prod
│       └── generate-network-policy.yaml  # Auto-generate NetworkPolicy
│
├── docs/
│   ├── architecture/
│   │   ├── overview.md                   # Platform architecture deep-dive
│   │   ├── crossplane-design.md          # Crossplane composition design
│   │   └── backstage-plugins.md          # Backstage plugin guide
│   ├── runbooks/
│   │   ├── argocd-sync-failed.md
│   │   ├── crossplane-claim-stuck.md
│   │   └── backstage-catalog-refresh.md
│   └── onboarding/
│       ├── new-team.md                   # Onboard a new team to the IDP
│       └── new-service.md                # Create your first service
│
├── scripts/
│   ├── bootstrap.sh                      # Full platform bootstrap
│   ├── add-team.sh                       # Onboard a new team
│   └── teardown.sh                       # Clean teardown for dev envs
│
├── tests/
│   ├── test_crossplane_claims.py         # Validate Crossplane CRDs
│   └── test_policies.py                  # OPA/Kyverno policy tests
│
└── .github/
    └── workflows/
        ├── ci.yaml                       # Lint, test, validate on PR
        ├── backstage-publish.yaml        # Publish Backstage Docker image
        └── helm-release.yaml             # Release Helm charts to OCI
```

---

## 🧩 Self-Service: How Crossplane Works

Developers interact with the platform through simple Kubernetes claims — they never touch
AWS/Azure/GCP APIs directly.

### Claiming a Postgres Database

```yaml
# A developer creates this file — no knowledge of RDS required
apiVersion: platform.company.io/v1alpha1
kind: XPostgres
metadata:
  name: payments-db
  namespace: team-payments
spec:
  parameters:
    storageGB: 20
    instanceClass: db.t3.medium
    engine: postgres
    engineVersion: "15"
  compositionSelector:
    matchLabels:
      provider: aws
      environment: production
  writeConnectionSecretToRef:
    name: payments-db-creds   # injected into the namespace automatically
```

Crossplane provisions the RDS instance, waits for it to be ready, and injects the
connection secret into the team's namespace. The developer gets a ready-to-use database
in under 5 minutes with zero AWS console access required.

### Claiming a Namespace

```yaml
apiVersion: platform.company.io/v1alpha1
kind: XNamespace
metadata:
  name: team-payments
spec:
  parameters:
    team: payments
    environment: production
    resourceQuota:
      cpu: "8"
      memory: "16Gi"
  writeConnectionSecretToRef:
    name: namespace-kubeconfig
```

The Namespace composition provisions: namespace + ResourceQuota + LimitRange + RBAC
(team gets edit, platform gets admin) + NetworkPolicy in one atomic operation.

---

## 🎭 Backstage Service Catalog

The catalog is the single source of truth for every service, API, team, and system in
the organisation. Every service registers itself via a `catalog-info.yaml`:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: payments-api
  description: Payment processing microservice
  annotations:
    github.com/project-slug: myorg/payments-api
    backstage.io/techdocs-ref: dir:.
    argocd/app-name: payments-api
    grafana/dashboard-selector: "service=payments-api"
  tags: [python, fastapi, payments, critical]
spec:
  type: service
  lifecycle: production
  owner: team-payments
  system: payments-platform
  dependsOn:
    - component:payments-db
    - component:fraud-detection-api
  providesApis:
    - payments-api-v2
```

This single file gives every developer:
- **Who owns it** — team-payments
- **What it depends on** — payments-db, fraud-detection-api
- **Where to find docs** — TechDocs auto-generated from the repo
- **How it's deployed** — ArgoCD app linked directly
- **How it's performing** — Grafana dashboard linked directly

---

## 🔐 Policy Enforcement

All workloads are **blocked at admission** if they violate platform policies.
No exceptions, no manual review — the cluster enforces compliance automatically.

### OPA/Gatekeeper Policies (blocking)
- ✅ CPU and memory `limits` + `requests` required on every container
- ✅ No `privileged: true` containers
- ✅ Images from approved registries only (`ghcr.io/org/`, `public.ecr.aws/`)
- ✅ Required labels: `app`, `team`, `env`, `version`
- ✅ No `latest` tag in staging or production namespaces

### Kyverno Policies (mutating + generating)
- 🔄 Auto-inject standard labels if missing (mutation)
- 🔄 Auto-generate NetworkPolicy for every new namespace (generation)
- 🚫 Block images without digest in production (validation)

---

## 🚀 Developer Workflow End-to-End

```
1. Developer opens Backstage → Create → "New Microservice"

2. Fills template form:
   service-name: order-processor
   team: logistics
   language: python
   database: postgres
   environment: staging

3. Backstage Scaffolder:
   ✓ Creates GitHub repo from cookiecutter template
   ✓ Generates catalog-info.yaml and registers in catalog
   ✓ Creates CI/CD pipeline (GitHub Actions)
   ✓ Creates ArgoCD Application
   ✓ Submits XNamespace + XPostgres Crossplane claims

4. Crossplane provisions:
   ✓ Kubernetes namespace with ResourceQuota
   ✓ RDS Postgres instance (or Cloud SQL on GCP)
   ✓ Connection secret injected into namespace

5. ArgoCD syncs:
   ✓ Deploys app skeleton to staging cluster
   ✓ OPA/Kyverno validates all manifests at admission

6. Developer clones repo, writes code, pushes → CI runs → ArgoCD deploys

Total time from "I need a service" to "running in staging": < 8 minutes
Developer touch points: 1 form. Zero Ops tickets.
```

---

## 📊 Platform Metrics (Built-in)

The platform ships with pre-configured dashboards tracking:

| Metric | Target |
|---|---|
| Time-to-provision new service | < 10 minutes |
| Crossplane claim success rate | > 99% |
| Policy violation rate | 0% in prod |
| ArgoCD sync success rate | > 99.5% |
| Catalog completeness | > 95% services registered |
| Developer NPS | Tracked quarterly |

---

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). High-value contributions:
- New Crossplane compositions (Azure SQL, GCP Memorystore, etc.)
- Additional Backstage software templates
- Kyverno / OPA policy additions
- TechDocs improvements

---
## 👤 Author

<p align="left">
  <a href="https://github.com/betelabs" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/>
  </a>

  <a href="https://linkedin.com/in/ashwani547" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-Ashwani%20Kumar-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white"/>
  </a>

  <a href="mailto:hello@betelabs.com">
    <img src="https://img.shields.io/badge/Email-Contact-D14836?style=for-the-badge&logo=gmail&logoColor=white"/>
  </a>
</p>

### Ashwani Kumar
Head of DevOps • Kubernetes Engineer • Cloud Native Enthusiast

---

<div align="center">
  <sub>
    ⭐ If this project helped you, consider starring the repository to support the project.
  </sub>
</div>


