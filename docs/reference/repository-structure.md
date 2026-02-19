# Repository Structure

Complete reference for the repository layout and file organization.

## Directory Tree

```
.
├── .github/
│   └── workflows/
│       ├── checkov.yaml           # Security scanning
│       ├── deploy-eks.yml         # Terraform EKS deployment
│       ├── deploy-k8s-app.yml     # Kubernetes app deployment
│       ├── docs-deploy.yaml       # Documentation deployment
│       ├── gitleaks.yaml          # Secret detection
│       ├── infracost.yaml         # Cost estimation
│       ├── lint-pr.yaml           # PR title validation
│       ├── pre-commit-ci.yaml     # Pre-commit hooks CI
│       ├── release.yaml           # Semantic release
│       └── tf-docs.yaml           # Terraform docs generation
│
├── docs/                          # MkDocs documentation source
│   ├── stylesheets/
│   │   └── extra.css              # Custom CSS
│   ├── getting-started/
│   │   ├── quick-start.md         # Quick start guide
│   │   └── usage.md               # Detailed usage guide
│   ├── user-guide/
│   │   ├── contributing.md        # Contributing guidelines
│   │   ├── commit-conventions.md  # Conventional commits guide
│   │   ├── security.md            # Security documentation
│   │   └── workflows.md           # CI/CD workflows reference
│   ├── reference/
│   │   ├── repository-structure.md # This file
│   │   ├── configuration.md       # Configuration reference
│   │   └── changelog.md           # Changelog
│   └── index.md                   # Documentation home
│
├── environments/
│   ├── dev/
│   │   └── dev.tfvars             # Dev environment variables
│   ├── qa/
│   │   └── qa.tfvars              # QA environment variables
│   └── prod/
│       └── prod.tfvars            # Prod environment variables
│
├── k8s/
│   └── apps/
│       └── nginx/                 # Example nginx application
│           ├── base/              # Shared base manifests
│           │   ├── kustomization.yaml
│           │   ├── namespace.yaml
│           │   ├── deployment.yaml
│           │   ├── service.yaml
│           │   └── configmap.yaml
│           └── overlays/          # Environment overrides
│               ├── dev/
│               │   ├── kustomization.yaml
│               │   └── deployment-patch.yaml
│               ├── qa/
│               │   ├── kustomization.yaml
│               │   └── deployment-patch.yaml
│               └── prod/
│                   ├── kustomization.yaml
│                   └── deployment-patch.yaml
│
├── modules/
│   ├── eks/                       # EKS + VPC module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── aws-load-balancer-controller/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── .checkov.yml                   # Checkov security scan config
├── .gitignore                     # Git ignore rules
├── .pre-commit-config.yaml        # Pre-commit hooks
├── .releaserc.json                # Semantic release config
├── .terraform-docs.yml            # terraform-docs config
├── .terraform-version             # Pinned Terraform version
├── .tflint.hcl                    # TFLint configuration
├── .templatesyncignore            # Template sync exclusions
├── CHANGELOG.md                   # Auto-generated changelog
├── CLAUDE.md                      # AI assistant context
├── README.md                      # Project documentation
├── locals.tf                      # Local values
├── main.tf                        # Root orchestration
├── mkdocs.yml                     # MkDocs configuration
├── outputs.tf                     # Terraform outputs
├── providers.tf                   # Provider configuration
├── requirements.txt               # Python dependencies (MkDocs)
├── variables.tf                   # Input variables
└── versions.tf                    # Provider version constraints
```

## Key Files

### Root Terraform Files

| File | Purpose |
|------|---------|
| `main.tf` | Orchestrates EKS and ALB Controller modules |
| `variables.tf` | All input variable definitions |
| `outputs.tf` | Exported values (cluster endpoint, VPC ID, etc.) |
| `locals.tf` | Computed values and naming conventions |
| `providers.tf` | AWS, Helm, and Kubernetes provider config |
| `versions.tf` | Terraform and provider version constraints |

### Configuration Files

| File | Purpose |
|------|---------|
| `.checkov.yml` | Checkov skip list and scan options |
| `.tflint.hcl` | TFLint rules and AWS plugin config |
| `.terraform-docs.yml` | terraform-docs output format |
| `.pre-commit-config.yaml` | Pre-commit hook definitions |
| `.releaserc.json` | Semantic release plugins and config |
| `mkdocs.yml` | Documentation site configuration |
| `requirements.txt` | Python packages for documentation |

### Modules

| Module | Purpose |
|--------|---------|
| `modules/eks` | VPC + EKS cluster with managed node groups |
| `modules/aws-load-balancer-controller` | ALB Controller IAM + Helm release |

## Naming Conventions

Resources follow the `{prefix}-{env}-{resource}` pattern:

```
my-project-dev-cluster        # EKS cluster
my-project-dev-vpc            # VPC
my-project-dev-eks-node-role  # IAM role
```

All Terraform variables and locals use `snake_case`.
