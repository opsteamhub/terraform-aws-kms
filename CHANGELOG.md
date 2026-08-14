# Changelog

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
