# Contributing to platform-engineering-idp

## What We Welcome
- New Crossplane compositions (Azure SQL, Redis, GCS buckets, etc.)
- Additional Backstage software templates
- Kyverno / OPA policy improvements (with tests)
- Runbook additions
- Documentation fixes and TechDocs improvements

## Development Setup
```bash
git clone https://github.com/ashwani547/platform-engineering-idp.git
cd platform-engineering-idp
# For Backstage development:
cd backstage && yarn install && yarn dev
```

## PR Guidelines
- Link to an issue
- Include a test or example if adding a new composition/policy
- Update docs/ if changing user-facing behaviour
- All Helm charts must pass `helm lint` before merge
