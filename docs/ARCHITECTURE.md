# Arquitetura

`kms_config` cria uma key e alias por chave lógica. Grants preservam o endereço legado baseado em `count`; a correção usa o índice correspondente sem trocar o endereço do recurso. Policies são construídas com `aws_iam_policy_document`.

Réplicas usam o provider legado `aws.dr`, cuja região vem de `disaster_recovery_region`. Esse desenho mantém compatibilidade, mas é uma limitação conhecida de módulos Terraform: um child module com provider configurado internamente não pode ser usado com `for_each`, `count` ou `depends_on`. Uma futura major deve mover a configuração do alias para o root consumer e receber `providers = { aws.dr = aws.dr }`.

O módulo não cria consumers nem executa rotação de material fora do mecanismo gerenciado pela AWS. Outputs expõem os recursos para que outros módulos usem ARN e key ID explicitamente.
