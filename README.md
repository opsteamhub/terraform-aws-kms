# Terraform AWS KMS

Módulo Terraform para criar chaves KMS, aliases, grants, policies customizadas e réplicas multi-Region.

## Compatibilidade

- Terraform `>= 1.7, < 2.0`
- AWS provider `>= 6.0, < 7.0`

## Uso básico

```hcl
module "kms" {
  source = "git::https://github.com/opsteamhub/terraform-aws-kms.git?ref=<release>"

  kms_config = {
    eks = {
      description = "EKS secrets encryption"
      multi_region = false

      tags = {
        Environment = "production"
        Project     = "platform"
        Owner       = "sre"
      }
    }
  }
}
```

Não use `master` em produção; após a release, fixe uma tag SemVer ou SHA.

## Grants

```hcl
kms_config = {
  application = {
    tags = {
      Environment = "production"
      Project     = "payments"
      Owner       = "platform"
    }

    grant = [{
      name              = "application"
      grantee_principal = "arn:aws:iam::123456789012:role/application"
      operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
    }]
  }
}
```

## Réplica multi-Region

O contrato legado ainda configura internamente o provider `aws.dr` usando `disaster_recovery_region`. Isso preserva consumidores existentes, mas impede `for_each`, `count` e `depends_on` no bloco deste módulo. Consulte [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) e planeje a migração antes de usar réplicas novas.

## Segurança

- `Environment`, `Project` e `Owner` são obrigatórias.
- Rotação permanece habilitada por default.
- O módulo não deve receber secrets; policies e principals são configuração IAM, não credenciais.
- `bypass_policy_lockout_safety_check = true` exige revisão explícita.

Consulte [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md) e [AGENTS.md](AGENTS.md).
