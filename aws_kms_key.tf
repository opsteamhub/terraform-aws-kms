#
# Deploy KMS Key.
#
resource "aws_kms_key" "k" {
  for_each     = {
    for k, v in var.kms_config:
      k => v if v["create"] == true
  }

  description                        = format("KMS Key - %s", each.key)
  key_usage                          = each.value["key_usage"]
  custom_key_store_id                = each.value["custom_key_store_id"]
  customer_master_key_spec           = each.value["customer_master_key_spec"]
  policy                             = try(
    data.aws_iam_policy_document.kms-policy[each.key].json,
    null
  ) 
  bypass_policy_lockout_safety_check = each.value["bypass_policy_lockout_safety_check"]
  deletion_window_in_days            = each.value["deletion_window_in_days"]
  is_enabled                         = each.value["is_enabled"]
  enable_key_rotation                = each.value["enable_key_rotation"]
  multi_region                       = each.value["multi_region"]
  tags                               = each.value["tags"]
}


#
# Deploy KMS Key Alias
#
resource "aws_kms_alias" "k_alias" {
  for_each      = var.kms_config

  name_prefix   = format("alias/%s-", each.key)
  target_key_id = aws_kms_key.k[each.key].key_id
}