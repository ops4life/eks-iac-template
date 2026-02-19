# CI/CD Workflows

This project includes 10 GitHub Actions workflows for automation.

## Workflow Overview

| Workflow | File | Trigger | Purpose |
|----------|------|---------|---------|
| Deploy EKS | `deploy-eks.yml` | Manual | Terraform plan/apply/destroy |
| Deploy App | `deploy-k8s-app.yml` | Manual | K8s app deploy/rollback |
| Pre-commit | `pre-commit-ci.yaml` | PR | Pre-commit checks + auto-fix |
| Security | `checkov.yaml` | PR/Push | Checkov security scanning |
| Cost | `infracost.yaml` | PR | Cost estimation |
| TF Docs | `tf-docs.yaml` | PR | Auto-generate Terraform docs |
| Secrets | `gitleaks.yaml` | PR/Push | Secret detection |
| Release | `release.yaml` | Push to main | Semantic versioning |
| Lint PR | `lint-pr.yaml` | PR | PR title validation |
| Docs | `docs-deploy.yaml` | Push to main / PR | Build and deploy documentation |

## Deploy EKS (`deploy-eks.yml`)

Manually triggered workflow for Terraform operations.

**Inputs:**

| Input | Options | Description |
|-------|---------|-------------|
| `environment` | dev, qa, prod | Target environment |
| `action` | plan, apply, destroy | Terraform action |

**Usage:**

1. Go to **Actions** → **Deploy EKS**
2. Click **Run workflow**
3. Select environment and action
4. Review plan output before applying

```yaml
# Terraform steps executed
terraform init
terraform fmt -check
terraform validate
terraform plan -var-file=environments/${{ env }}/$${{ env }}.tfvars
terraform apply -var-file=environments/${{ env }}/${{ env }}.tfvars  # if action=apply
```

!!! danger "Destroy Action"
    The `destroy` action will permanently delete all infrastructure. Use with extreme caution in production.

## Deploy App (`deploy-k8s-app.yml`)

Manually triggered workflow for Kubernetes application deployments.

**Inputs:**

| Input | Options | Description |
|-------|---------|-------------|
| `environment` | dev, qa, prod | Target environment |
| `app_name` | nginx | Application to deploy |
| `action` | deploy, rollback | Deployment action |

**Steps:**

1. Configure AWS credentials
2. Update kubeconfig for EKS cluster
3. Build Kustomize manifests
4. Apply or rollback deployment

## Pre-commit CI (`pre-commit-ci.yaml`)

Runs all pre-commit hooks on pull requests and auto-commits any formatting fixes.

**Tools installed:**

- Python 3.10
- Terraform 1.10.5
- TFLint
- terraform-docs
- Checkov
- Gitleaks
- pre-commit

**Auto-fix:** If hooks modify files (e.g., `terraform fmt`, `terraform-docs`), changes are automatically committed back to the PR branch.

## Security Scan (`checkov.yaml`)

Runs Checkov security scanning on all Terraform configurations.

- Outputs results as JSON artifact (30-day retention)
- Soft-fail mode: reports issues without blocking merges
- Configuration via `.checkov.yml`

## Cost Estimation (`infracost.yaml`)

Posts infrastructure cost estimates as PR comments.

**Requirements:** `INFRACOST_API_KEY` secret must be set.

**Output:** Shows monthly cost breakdown and diff between base and PR branch.

## Terraform Docs (`tf-docs.yaml`)

Auto-generates Terraform documentation in `README.md` between `BEGIN_TF_DOCS` and `END_TF_DOCS` markers.

## Secret Detection (`gitleaks.yaml`)

Scans commits and PR diffs for hardcoded secrets.

**Requirements:** `GITLEAKS_LICENSE` secret (optional for private repos).

## Release (`release.yaml`)

Automated semantic versioning on push to `main`.

**Process:**

1. Analyzes commits since last release
2. Determines version bump (major/minor/patch)
3. Updates `CHANGELOG.md`
4. Creates GitHub Release with release notes
5. Tags the release

**Requires:** `WORKFLOW_TOKEN` secret with `contents: write` permission.

## PR Lint (`lint-pr.yaml`)

Validates PR titles follow [Conventional Commits](commit-conventions.md) format.

**Allowed types:** `fix`, `feat`, `docs`, `ci`, `chore`, `style`, `refactor`, `test`, `revert`

Posts a sticky comment on validation failures with guidance.

## Documentation (`docs-deploy.yaml`)

Builds and deploys MkDocs documentation to GitHub Pages.

**Triggers:**
- Push to `main` (when docs files change) → build + deploy
- Pull request → build only (validation)
- Manual dispatch → build + deploy

**Process:**

1. Install Python dependencies (`requirements.txt`)
2. Auto-configure repository URLs from `GITHUB_REPOSITORY`
3. Commit URL changes back to repository
4. Build documentation with `mkdocs build --strict`
5. Deploy to GitHub Pages (on push to main)

**Setup:** Enable GitHub Pages in repository settings with source set to **GitHub Actions**.

## Required GitHub Secrets

| Secret | Required | Description |
|--------|----------|-------------|
| `AWS_ACCESS_KEY_ID` | Yes | AWS access key for deployments |
| `AWS_SECRET_ACCESS_KEY` | Yes | AWS secret key for deployments |
| `AWS_REGION` | Yes | AWS region |
| `INFRACOST_API_KEY` | No | Infracost cost estimation |
| `GITLEAKS_LICENSE` | No | Gitleaks for private repos |
| `WORKFLOW_TOKEN` | No | GitHub token for auto-commits |
