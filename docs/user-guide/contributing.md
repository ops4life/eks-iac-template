# Contributing

Thank you for contributing to the EKS Infrastructure Template! This guide explains how to contribute effectively.

## Getting Started

1. **Fork** the repository on GitHub
2. **Clone** your fork locally:

    ```bash
    git clone https://github.com/your-ops4life/eks-iac-template.git
    cd github-repo-template
    ```

3. **Install** pre-commit hooks:

    ```bash
    pre-commit install
    ```

4. **Create** a feature branch:

    ```bash
    git checkout -b feat/my-new-feature
    ```

## Development Workflow

### Branching Strategy

| Branch Type | Pattern | Example |
|-------------|---------|---------|
| Feature | `feat/` | `feat/add-cluster-autoscaler` |
| Bug fix | `fix/` | `fix/node-group-scaling` |
| Maintenance | `chore/` | `chore/update-terraform-version` |
| Documentation | `docs/` | `docs/update-readme` |

!!! warning "Never commit directly to `main`"
    All changes must go through a pull request.

### Making Changes

1. Make your changes following the code style
2. Run pre-commit to validate:

    ```bash
    pre-commit run --all-files
    ```

3. Commit following [Conventional Commits](commit-conventions.md):

    ```bash
    git commit -m "feat(eks): add cluster autoscaler support"
    ```

4. Push and open a Pull Request

## Pull Request Guidelines

### PR Title

Follow the [Conventional Commits](commit-conventions.md) format:

```
feat(eks): add cluster autoscaler support
fix(alb): resolve health check configuration
docs: update quick start guide
```

### PR Checklist

- [ ] Code follows existing patterns and style
- [ ] Terraform files are formatted (`terraform fmt -recursive`)
- [ ] `terraform validate` passes
- [ ] Pre-commit hooks pass
- [ ] Documentation updated if needed
- [ ] Tests added for new functionality

### Automated Checks

When you open a PR, these checks run automatically:

| Check | Tool | Purpose |
|-------|------|---------|
| Format | terraform fmt | Code style |
| Validate | terraform validate | Configuration validity |
| Lint | TFLint | Best practices |
| Security | Checkov | Security vulnerabilities |
| Secrets | Gitleaks | Secret detection |
| Cost | Infracost | Cost impact |
| Docs | terraform-docs | Documentation generation |

## Terraform Module Guidelines

### Variable Documentation

All variables must have descriptions:

```hcl
variable "cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
  default     = "1.31"
}
```

### Naming Conventions

- Use `snake_case` for all resource names
- Follow the `{prefix}-{env}-{resource}` pattern:

```hcl
name = "${var.prefix}-${var.env}-cluster"
```

### Resource Tagging

Add common tags to all resources:

```hcl
tags = merge(local.common_tags, {
  Name = "${var.prefix}-${var.env}-resource"
})
```

## Documentation Updates

When adding features, update relevant documentation in `docs/`:

- New variables → `docs/reference/configuration.md`
- New workflows → `docs/user-guide/workflows.md`
- Architecture changes → `docs/index.md`

Run the docs locally to preview:

```bash
pip install -r requirements.txt
mkdocs serve
```

Open [http://localhost:8000](http://localhost:8000) to preview.

## Reporting Issues

Use [GitHub Issues](https://github.com/ops4life/eks-iac-template/issues) to report:

- Bugs with steps to reproduce
- Feature requests with use cases
- Documentation improvements

## Code of Conduct

Be respectful, inclusive, and constructive in all interactions.
