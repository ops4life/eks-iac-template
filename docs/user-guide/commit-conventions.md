# Commit Conventions

This project follows [Conventional Commits](https://www.conventionalcommits.org/) for automated versioning and changelog generation.

## Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

## Types

| Type | Description | Version Bump |
|------|-------------|--------------|
| `feat` | New feature | Minor (1.x.0) |
| `fix` | Bug fix | Patch (1.0.x) |
| `chore` | Maintenance tasks | None |
| `docs` | Documentation changes | None |
| `refactor` | Code refactoring | None |
| `test` | Adding or updating tests | None |
| `ci` | CI/CD pipeline changes | None |
| `style` | Code style changes | None |
| `revert` | Revert a previous commit | Patch |
| `BREAKING CHANGE` | Breaking API change | Major (x.0.0) |

## Scopes

Common scopes for this project:

| Scope | Description |
|-------|-------------|
| `eks` | EKS cluster changes |
| `vpc` | VPC/networking changes |
| `alb` | ALB Controller changes |
| `k8s` | Kubernetes manifest changes |
| `ci` | CI/CD workflow changes |
| `docs` | Documentation changes |
| `deps` | Dependency updates |

## Examples

### Feature Commits

```bash
# New feature (minor version bump)
git commit -m "feat(eks): add cluster autoscaler support"

# New feature with body
git commit -m "feat(alb): add WAF integration

Add WAF ACL support to the ALB Controller for enhanced security.
Supports both regional and global WAFs."
```

### Bug Fix Commits

```bash
# Simple bug fix (patch version bump)
git commit -m "fix(eks): resolve node group scaling issue"

# Fix with issue reference
git commit -m "fix(vpc): correct subnet CIDR calculation

Fixes incorrect CIDR block assignment for private subnets
in multi-AZ deployments.

Closes #42"
```

### Maintenance Commits

```bash
# Dependency update (no version bump)
git commit -m "chore(deps): update terraform-aws-eks to v20.0"

# CI changes (no version bump)
git commit -m "ci: add infracost workflow for cost estimation"

# Documentation (no version bump)
git commit -m "docs: update quick start guide"
```

### Breaking Changes

```bash
# Breaking change (major version bump)
git commit -m "feat(eks)!: restructure node group configuration

BREAKING CHANGE: node_groups variable schema has changed.
The 'instance_type' field is now 'instance_types' (list).

Migration:
  Before: instance_type = \"t3.medium\"
  After:  instance_types = [\"t3.medium\", \"t3a.medium\"]"
```

## PR Title Convention

Pull request titles must also follow Conventional Commits format — this is enforced by the `lint-pr.yaml` workflow:

```
feat(eks): add support for managed node group taints
fix(ci): resolve terraform plan output truncation
chore(deps): bump terraform-aws-modules/eks to v20.31
```

## Automated Versioning

Commits are automatically analyzed by `semantic-release` on push to `main`:

1. `BREAKING CHANGE` → major version (1.0.0 → 2.0.0)
2. `feat` → minor version (1.0.0 → 1.1.0)
3. `fix`, `revert` → patch version (1.0.0 → 1.0.1)
4. Everything else → no release

The `CHANGELOG.md` is automatically updated and a GitHub Release is created.
