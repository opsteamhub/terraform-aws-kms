# Repository instructions

This repository contains a reusable Terraform module for AWS KMS. Treat `variables.tf` as the input contract, `outputs.tf` as the output contract, and `docs/` as the design and migration record.

## Working rules

- Never run `terraform apply` or `destroy` against a real AWS account while developing this module.
- Do not commit state, plans, credentials, customer identifiers, provider binaries, or backend configuration.
- Preserve resource addresses unless an intentional breaking change is documented.
- Require `Environment`, `Project`, and `Owner` on every key.
- Keep rotation enabled and policy lockout protection enabled by default.
- Treat key deletion, replacement, aliases, policies, grants, and replica changes as high-risk.
- Add positive and negative mocked tests for contract changes.
- Use Conventional Commits in English. Do not create a tag or release from a feature branch.

## Required checks

```bash
terraform fmt -check -recursive
terraform init -backend=false -input=false
terraform validate
terraform test -test-directory=testing
terraform -chdir=examples/basic init -backend=false -input=false
terraform -chdir=examples/basic validate
tflint --init
tflint --recursive --format compact
trivy config --severity HIGH,CRITICAL --exit-code 1 .
```

Validate `.kiro/agents/local-agent.json` against its pinned schema before proposing changes.
