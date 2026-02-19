# EKS Infrastructure Template

Production-ready EKS infrastructure template with Terraform, Kustomize, and CI/CD pipelines.

## Features

- EKS cluster with VPC and managed node groups
- AWS Load Balancer Controller for ALB Ingress
- Multi-environment support (dev, qa, prod)
- GitHub Actions CI/CD workflows
- Pre-commit hooks with security scanning
- Cost estimation with Infracost
- Semantic versioning and releases

## Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [kustomize](https://kustomize.io/)
- [pre-commit](https://pre-commit.com/)

### 1. Customize

Search for `# TODO: Customize` comments and update:

- `variables.tf` - Default region and project prefix
- `environments/*/` - Environment-specific configurations
- `.github/workflows/deploy-k8s-app.yml` - Cluster name prefix

### 2. Initialize

```bash
pre-commit install
terraform init
```

### 3. Deploy EKS

```bash
# Plan
terraform plan -var-file=environments/dev/dev.tfvars

# Apply
terraform apply -var-file=environments/dev/dev.tfvars

# Configure kubectl
aws eks --region <region> update-kubeconfig --name <prefix>-dev-cluster
```

### 4. Deploy Application

```bash
# Build and preview manifests
kustomize build k8s/apps/nginx/overlays/dev/

# Deploy
kubectl apply -k k8s/apps/nginx/overlays/dev/

# Verify
kubectl get all -n dev -l app=nginx
```

## Architecture

```
                    +------------------+
                    |   GitHub Actions |
                    +--------+---------+
                             |
              +--------------+--------------+
              |                             |
    +---------v---------+       +-----------v-----------+
    |  Terraform        |       |  kubectl/Kustomize    |
    |  (Infrastructure) |       |  (Applications)       |
    +---------+---------+       +-----------+-----------+
              |                             |
    +---------v-----------------------------v-----------+
    |                    AWS                             |
    |  +-------------+  +----------------------------+  |
    |  |     VPC     |  |         EKS Cluster        |  |
    |  |  +-------+  |  |  +--------+  +---------+  |  |
    |  |  |Public |  |  |  | Node   |  | Node    |  |  |
    |  |  |Subnet |  |  |  | Group  |  | Group   |  |  |
    |  |  +-------+  |  |  | (SPOT) |  |(ON_DEM) |  |  |
    |  |  +-------+  |  |  +--------+  +---------+  |  |
    |  |  |Private|  |  |                            |  |
    |  |  |Subnet |  |  |  +----------------------+  |  |
    |  |  +-------+  |  |  | ALB Controller       |  |  |
    |  +-------------+  |  +----------------------+  |  |
    |                    +----------------------------+  |
    +----------------------------------------------------+
```

## Environment Configurations

| Setting | Dev | QA | Prod |
|---------|-----|-----|------|
| AZs | 2 | 3 | 3 |
| NAT Gateway | Single | Single | Per AZ |
| SPOT Nodes | Yes | Yes | Yes |
| ON_DEMAND Nodes | No | Yes | Yes |
| SPOT min/max | 1/3 | 1/3 | 2/5 |
| ON_DEMAND min/max | - | 1/2 | 2/4 |

## Project Structure

```
.
├── main.tf                    # Root orchestration
├── variables.tf               # Input variables
├── outputs.tf                 # Outputs
├── locals.tf                  # Local values
├── versions.tf                # Terraform/provider versions
├── providers.tf               # Provider configuration
├── modules/
│   ├── eks/                   # EKS + VPC module
│   └── aws-load-balancer-controller/
├── environments/
│   ├── dev/dev.tfvars
│   ├── qa/qa.tfvars
│   └── prod/prod.tfvars
├── k8s/apps/nginx/            # Example nginx app
│   ├── base/
│   └── overlays/{dev,qa,prod}/
└── .github/workflows/         # CI/CD pipelines
```

## CI/CD Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| deploy-eks.yml | Manual | Terraform plan/apply/destroy |
| deploy-k8s-app.yml | Manual | K8s app deploy/rollback |
| pre-commit-ci.yaml | PR | Pre-commit checks |
| checkov.yaml | PR/Push | Security scanning |
| infracost.yaml | PR | Cost estimates |
| tf-docs.yaml | PR | Auto-generate docs |
| gitleaks.yaml | PR/Push | Secret detection |
| release.yaml | Push to main | Semantic release |
| lint-pr.yaml | PR | PR title validation |

## GitHub Secrets Required

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `AWS_REGION` | AWS region |
| `INFRACOST_API_KEY` | Infracost API key (optional) |
| `GITLEAKS_LICENSE` | GitLeaks license (optional) |
| `WORKFLOW_TOKEN` | GitHub token for pre-commit auto-fix |

## Adding New Applications

1. Create `k8s/apps/{app-name}/base/` with deployment, service, configmap
2. Create overlays in `k8s/apps/{app-name}/overlays/{dev,qa,prod}/`
3. Add app to `.github/workflows/deploy-k8s-app.yml` choices
4. Test with `kustomize build` and `kubectl apply --dry-run`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.1 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_load_balancer_controller"></a> [aws\_load\_balancer\_controller](#module\_aws\_load\_balancer\_controller) | ./modules/aws-load-balancer-controller | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ./modules/eks | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | AMI type for EKS nodes | `string` | `"AL2_x86_64"` | no |
| <a name="input_availability_zones_count"></a> [availability\_zones\_count](#input\_availability\_zones\_count) | Number of availability zones to use for EKS VPC | `number` | `3` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes cluster version | `string` | `"1.31"` | no |
| <a name="input_enable_alb_controller"></a> [enable\_alb\_controller](#input\_enable\_alb\_controller) | Enable AWS Load Balancer Controller deployment | `bool` | `false` | no |
| <a name="input_enable_eks"></a> [enable\_eks](#input\_enable\_eks) | Enable EKS cluster deployment | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | The environment to deploy (dev, qa, prod) | `string` | n/a | yes |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | EKS managed node groups configuration | `any` | `{}` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix for all resource names | `string` | `"my-project"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy resources | `string` | `"ap-southeast-1"` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Use single NAT gateway for all private subnets (cost optimization) | `bool` | `true` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_controller_iam_role_arn"></a> [alb\_controller\_iam\_role\_arn](#output\_alb\_controller\_iam\_role\_arn) | ARN of IAM role for AWS Load Balancer Controller |
| <a name="output_alb_controller_version"></a> [alb\_controller\_version](#output\_alb\_controller\_version) | Version of AWS Load Balancer Controller Helm chart |
| <a name="output_configure_kubectl"></a> [configure\_kubectl](#output\_configure\_kubectl) | Command to configure kubectl for EKS cluster access |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint for EKS control plane |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | The name of the EKS cluster |
| <a name="output_eks_cluster_security_group_id"></a> [eks\_cluster\_security\_group\_id](#output\_eks\_cluster\_security\_group\_id) | Security group ID attached to the EKS cluster |
| <a name="output_eks_oidc_provider_arn"></a> [eks\_oidc\_provider\_arn](#output\_eks\_oidc\_provider\_arn) | ARN of the OIDC Provider for EKS (for IRSA) |
| <a name="output_eks_private_subnets"></a> [eks\_private\_subnets](#output\_eks\_private\_subnets) | List of IDs of private subnets |
| <a name="output_eks_public_subnets"></a> [eks\_public\_subnets](#output\_eks\_public\_subnets) | List of IDs of public subnets |
| <a name="output_eks_vpc_id"></a> [eks\_vpc\_id](#output\_eks\_vpc\_id) | The ID of the VPC created for EKS |
| <a name="output_environment"></a> [environment](#output\_environment) | The environment name |
| <a name="output_region"></a> [region](#output\_region) | The AWS region where resources are deployed |
| <a name="output_resource_prefix"></a> [resource\_prefix](#output\_resource\_prefix) | The prefix used for resource naming |
<!-- END_TF_DOCS -->
