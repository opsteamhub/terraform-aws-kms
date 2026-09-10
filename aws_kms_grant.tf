locals {
  grants = flatten([
    for config_key, config in var.kms_config : [
      for grant in coalesce(config.grant, []) : merge(grant, {
        key_id = aws_kms_key.k[config_key].key_id
      })
    ] if config.create
  ])
}

# count is intentionally retained to preserve the legacy state address.
resource "aws_kms_grant" "k_grant_by_count" {
  count = length(local.grants)

  dynamic "constraints" {
    for_each = local.grants[count.index].constraints == null ? [] : [local.grants[count.index].constraints]
    content {
      encryption_context_equals = constraints.value.encryption_context_equals
      encryption_context_subset = constraints.value.encryption_context_subset
    }
  }

  grant_creation_tokens = local.grants[count.index].grant_creation_tokens
  grantee_principal     = local.grants[count.index].grantee_principal
  key_id                = local.grants[count.index].key_id
  name                  = local.grants[count.index].name
  operations            = local.grants[count.index].operations
  retire_on_delete      = local.grants[count.index].retire_on_delete
  retiring_principal    = local.grants[count.index].retiring_principal
}
