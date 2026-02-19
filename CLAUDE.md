# CLAUDE.md

## Repository Overview

EKS infrastructure template for AWS deployments with Terraform, Kustomize, and CI/CD pipelines.

## Key Commands

```bash
# Initialize Terraform
terraform init

# Format and validate
terraform fmt -recursive
terraform validate

# Plan/Apply for specific environment
terraform plan -var-file=environments/dev/dev.tfvars
terraform apply -var-file=environments/dev/dev.tfvars

# Pre-commit hooks
pre-commit install
pre-commit run --all-files

# Lint
tflint --init && tflint --config=.tflint.hcl

# Security scan
checkov --config-file .checkov.yml

# K8s manifests
kustomize build k8s/apps/nginx/overlays/dev/
kubectl apply -k k8s/apps/nginx/overlays/dev/
```

## Architecture

- **Terraform >= 1.0**, AWS provider ~> 5.0
- **Backend**: Local by default, S3 backend template in versions.tf
- **Modules**: `modules/eks` (VPC + EKS), `modules/aws-load-balancer-controller`
- **Environments**: dev, qa, prod with tfvars in `environments/{env}/{env}.tfvars`
- **K8s**: Kustomize with base + overlays per environment
- **Naming**: `{prefix}-{env}-{resource}` pattern, snake_case enforced

## Environment Configs

- **dev**: 2 AZs, SPOT only, single NAT, 2 nodes
- **qa**: 3 AZs, mixed SPOT/ON_DEMAND, single NAT
- **prod**: 3 AZs, NAT per AZ, higher node counts

## CI/CD Workflows

- **deploy-eks.yml**: Terraform plan/apply/destroy
- **deploy-k8s-app.yml**: K8s app deploy/rollback
- **pre-commit-ci.yaml**: Pre-commit checks on PRs
- **checkov.yaml**: Security scanning
- **infracost.yaml**: Cost estimates on PRs
- **tf-docs.yaml**: Auto-generate TF docs
- **gitleaks.yaml**: Secret detection
- **release.yaml**: Semantic release
- **lint-pr.yaml**: PR title linting

## Branching

- Never commit directly to `main`
- Use feature branches: `feat/`, `fix/`, `chore/`
- Follow Conventional Commits

## Commit Convention

```
<type>(<scope>): <subject>
```

Types: feat, fix, chore, docs, refactor, test
