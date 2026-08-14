# Política de segurança

Reporte vulnerabilidades pelo fluxo privado de [GitHub Security Advisories](https://github.com/opsteamhub/terraform-aws-kms/security/advisories/new) ou diretamente a um mantenedor da OpsTeamHub. Não publique credenciais, state, policies de clientes ou provas executadas em produção.

Revise principals, condições, ações, grants e proteção contra lockout. Exclusão de chave KMS é uma operação irreversível após a janela programada; nunca use este módulo para apagar uma chave sem aprovação explícita, backup/recuperação avaliados e inventário dos consumidores.
