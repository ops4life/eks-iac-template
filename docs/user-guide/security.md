# Security

This project includes multiple layers of security scanning and best practices.

## Security Tools

### Checkov

[Checkov](https://www.checkov.io/) scans Terraform configurations for security misconfigurations.

**Configuration:** `.checkov.yml`

```yaml
# Run manually
checkov --config-file .checkov.yml
```

Skipped checks (with justification in `.checkov.yml`):

| Check ID | Reason |
|----------|--------|
| CKV_AWS_18 | S3 access logging not required for state bucket |
| CKV_AWS_21 | S3 versioning managed separately |
| CKV2_AWS_62 | S3 event notifications not required |
| CKV_AWS_144 | S3 cross-region replication not required |
| CKV_AWS_145 | KMS encryption uses AWS managed keys |
| CKV_AWS_300 | S3 lifecycle policies managed separately |
| CKV2_AWS_61 | S3 request metrics not required |

### TFLint

[TFLint](https://github.com/terraform-linters/tflint) enforces Terraform best practices and AWS-specific rules.

**Configuration:** `.tflint.hcl`

```bash
# Run manually
tflint --init && tflint --config=.tflint.hcl
```

### Gitleaks

[Gitleaks](https://gitleaks.io/) detects hardcoded secrets and credentials in code.

```bash
# Run manually
gitleaks detect --source . --verbose
```

!!! danger "Never commit secrets"
    Always use environment variables, AWS Secrets Manager, or GitHub Secrets for sensitive values.

## IAM Security

### Least Privilege Principle

All IAM roles follow least privilege:

- EKS node roles have only required permissions
- ALB Controller uses IRSA (IAM Roles for Service Accounts)
- CI/CD workflows use minimal IAM permissions

### IRSA (IAM Roles for Service Accounts)

The ALB Controller uses IRSA for keyless authentication:

```hcl
module "aws_load_balancer_controller" {
  source = "./modules/aws-load-balancer-controller"

  # IRSA automatically scoped to the service account
  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
}
```

### GitHub OIDC (Recommended for Production)

Replace static AWS credentials with GitHub OIDC:

```yaml
# In GitHub Actions workflow
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::123456789:role/github-actions-role
    aws-region: ap-southeast-1
```

```hcl
# Terraform OIDC trust policy
data "aws_iam_policy_document" "github_actions" {
  statement {
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:ops4life/eks-iac-template:*"]
    }
  }
}
```

## Network Security

### VPC Security

- Private subnets for EKS nodes (no direct internet access)
- Public subnets only for load balancers
- NAT Gateway for outbound traffic from private subnets
- Security groups with minimal ingress rules

### EKS Security

- EKS control plane API endpoint access controlled
- Node-to-node and pod-to-pod network policies
- Secrets encryption at rest (AWS KMS)

## Sensitive Data Management

### tfvars Files

The `.gitignore` excludes all `.tfvars` files except environment configs:

```gitignore
*.tfvars
*.tfvars.json
!dev.tfvars
!qa.tfvars
!prod.tfvars
```

!!! warning "Do not add secrets to tfvars files"
    Environment tfvars are committed to the repository. Never add sensitive values.

### GitHub Secrets

Store sensitive values as GitHub Secrets:

```yaml
env:
  AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

## Reporting Security Issues

Please report security vulnerabilities privately via [GitHub Security Advisories](https://github.com/ops4life/eks-iac-template/security/advisories/new) rather than public issues.
