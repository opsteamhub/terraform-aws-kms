# Changelog

## [2.0.0](https://github.com/opsteamhub/terraform-aws-kms/compare/v1.0.0...v2.0.0) (2026-09-10)


### ⚠ BREAKING CHANGES

* Terraform 1.7, AWS provider 6, and mandatory Environment, Project, and Owner tags are now required.

### Features

* modernize KMS module for AWS provider 6 ([86089eb](https://github.com/opsteamhub/terraform-aws-kms/commit/86089eb451e6242996daaf1d64976e610f1cd55e))

## [Unreleased]

### Added

- Contratos de Terraform/AWS provider, tags obrigatórias, validações, testes mockados, CI e documentação agentic-ready.

### Fixed

- Grants múltiplos agora usam `count.index` em vez de repetir o primeiro grant.
- Alterações de grant deixam de ser ignoradas integralmente.
- Replica passa a usar sua própria policy e combina tags nulas com segurança.
- Alias deixa de referenciar uma key inexistente quando `create = false`.
- O input `description` passa a ser aplicado à key.

### Removed

- Testes legados com conta fixa e dependência local ausente; foram substituídos por testes mockados reproduzíveis.
