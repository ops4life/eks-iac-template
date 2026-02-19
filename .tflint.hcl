# TFLint Configuration

config {
  format = "compact"
  plugin_dir = "~/.tflint.d/plugins"

  call_module_type = "all"
  force = false
}

# AWS Plugin for AWS-specific rules
plugin "aws" {
  enabled = true
  version = "0.38.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Terraform Core Rules

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true

  variable {
    format = "snake_case"
  }

  locals {
    format = "snake_case"
  }

  output {
    format = "snake_case"
  }

  resource {
    format = "snake_case"
  }

  module {
    format = "snake_case"
  }

  data {
    format = "snake_case"
  }
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
  style   = "flexible"
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = false
}

rule "aws_resource_missing_tags" {
  enabled = false
  tags = ["Name", "Environment"]
}
