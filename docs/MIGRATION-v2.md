# Migração para v2

1. Fixe o consumidor na revisão atual antes do upgrade; historicamente o repositório não possuía releases.
2. Atualize Terraform para 1.7+ e AWS provider para 6.x.
3. Adicione `Environment`, `Project` e `Owner` em cada `kms_config[*].tags`.
4. Revise plans de grants: o bug anterior repetia o primeiro item e ignorava mudanças. A v2 corrige os índices e passa a reconciliar alterações.
5. Para réplicas, informe `disaster_recovery_region`, mantenha `multi_region = true` e revise a policy específica da réplica.
6. Execute plan em sandbox e inventarie todos os ARNs consumidores antes de aplicar.

Rollback exige restaurar a referência anterior e confirmar que nenhuma key, alias ou grant foi excluído ou substituído. Não tente recriar material de chave apagado.
