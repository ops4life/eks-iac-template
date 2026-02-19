# Configuration Reference

Complete reference for all configurable variables and settings.

## Terraform Variables

### Root Module Variables

| Variable | Type | Default | Required | Description |
|----------|------|---------|----------|-------------|
| `env` | `string` | — | Yes | Environment name (dev, qa, prod) |
| `prefix` | `string` | `"my-project"` | No | Resource name prefix |
| `region` | `string` | `"ap-southeast-1"` | No | AWS region |
| `enable_eks` | `bool` | `false` | No | Enable EKS cluster deployment |
| `enable_alb_controller` | `bool` | `false` | No | Enable ALB Controller deployment |
| `vpc_cidr` | `string` | `"10.0.0.0/16"` | No | VPC CIDR block |
| `cluster_version` | `string` | `"1.31"` | No | Kubernetes version |
| `ami_type` | `string` | `"AL2_x86_64"` | No | EKS node AMI type |
| `single_nat_gateway` | `bool` | `true` | No | Use single NAT (cost optimization) |
| `availability_zones_count` | `number` | `3` | No | Number of AZs |
| `node_groups` | `any` | `{}` | No | EKS managed node group configs |

### Node Groups Configuration

The `node_groups` variable accepts a map of node group configurations:

```hcl
node_groups = {
  spot = {
    capacity_type  = "SPOT"
    instance_types = ["t3.medium", "t3a.medium"]
    ami_type       = "AL2_x86_64"
    min_size       = 1
    max_size       = 3
    desired_size   = 2
    disk_size      = 20
    labels = {
      role = "spot"
    }
    taints = []
  }
  on_demand = {
    capacity_type  = "ON_DEMAND"
    instance_types = ["t3.medium"]
    ami_type       = "AL2_x86_64"
    min_size       = 1
    max_size       = 2
    desired_size   = 1
    disk_size      = 20
    labels = {
      role = "on-demand"
    }
    taints = []
  }
}
```

## Environment Configurations

### Dev Environment

```hcl
# environments/dev/dev.tfvars
env                      = "dev"
prefix                   = "my-project"      # TODO: Customize
region                   = "ap-southeast-1"  # TODO: Customize
enable_eks               = true
enable_alb_controller    = true
vpc_cidr                 = "10.0.0.0/16"
cluster_version          = "1.31"
availability_zones_count = 2
single_nat_gateway       = true              # Cost optimization

node_groups = {
  spot = {
    capacity_type  = "SPOT"
    instance_types = ["t3.medium", "t3a.medium"]
    min_size       = 1
    max_size       = 3
    desired_size   = 2
  }
}
```

### Environment Comparison

| Setting | Dev | QA | Prod |
|---------|-----|----|------|
| AZs | 2 | 3 | 3 |
| NAT Gateway | Single | Single | Per AZ |
| SPOT nodes | Yes | Yes | Yes |
| ON_DEMAND nodes | No | Yes | Yes |
| SPOT min/max | 1/3 | 1/3 | 2/5 |
| ON_DEMAND min/max | — | 1/2 | 2/4 |

## MkDocs Configuration

**File:** `mkdocs.yml`

Key settings:

| Setting | Description |
|---------|-------------|
| `site_name` | Documentation site title |
| `site_url` | Base URL (auto-configured by CI) |
| `repo_url` | GitHub repository URL (auto-configured by CI) |
| `theme.name` | `material` (Material for MkDocs) |
| `plugins` | search, git-revision-date-localized, minify |

The `docs-deploy.yaml` workflow auto-updates `site_url`, `repo_url`, and `repo_name` using the actual repository name on first deployment.

## Pre-commit Configuration

**File:** `.pre-commit-config.yaml`

| Hook | Version | Purpose |
|------|---------|---------|
| pre-commit-hooks | v6.0.0 | General file checks |
| pre-commit-terraform | v1.105.0 | Terraform-specific hooks |
| gitleaks | v8.30.0 | Secret detection |

### Terraform Hooks

| Hook | Description |
|------|-------------|
| `terraform_fmt` | Format Terraform files |
| `terraform_validate` | Validate configuration |
| `terraform_docs` | Generate README documentation |
| `terraform_tflint` | Lint with TFLint |
| `terraform_checkov` | Security scan |

## TFLint Configuration

**File:** `.tflint.hcl`

- AWS plugin: `v0.38.0`
- Enforces naming conventions (snake_case)
- Checks for deprecated resources
- Validates documentation completeness

## Checkov Configuration

**File:** `.checkov.yml`

- Quiet mode (minimal output)
- Soft-fail (reports but doesn't block)
- 7 skipped checks with documented justifications

## Terraform Docs Configuration

**File:** `.terraform-docs.yml`

- Output mode: inject (updates existing README.md)
- Recursive: generates docs for all modules
- Sections: requirements, providers, modules, inputs, outputs

## Semantic Release Configuration

**File:** `.releaserc.json`

Plugins:
1. `@semantic-release/commit-analyzer` - Determines version bump
2. `@semantic-release/release-notes-generator` - Generates changelog
3. `@semantic-release/changelog` - Updates CHANGELOG.md
4. `@semantic-release/github` - Creates GitHub Release
5. `@semantic-release/git` - Commits CHANGELOG.md

## Terraform Version

**File:** `.terraform-version`

Pins Terraform to `1.10.5` for consistent behavior across environments (used by `tfenv`).
