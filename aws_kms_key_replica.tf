#
# Deploy AWS KMS Replica if required DR
#
resource "aws_kms_replica_key" "k_replica" {
  for_each     = {
    for k, v in var.kms_config:
      k => v if (v["replica"] != null)
  }

  bypass_policy_lockout_safety_check = each.value["replica"]["bypass_policy_lockout_safety_check"]
  deletion_window_in_days            = each.value["replica"]["deletion_window_in_days"]
  description                        = format("KMS Key Replica for the Primary Key - %s", aws_kms_key.k[each.key].id)
  enabled                            = each.value["replica"]["enabled"]
  primary_key_arn                    = aws_kms_key.k[each.key].arn
  policy                             = try(
    data.aws_iam_policy_document.kms-policy[each.key].json,
    null
  ) 
  tags                    = merge(
    each.value["tags"],
    each.value["replica"]["tags"]
  )
  provider                = aws.dr
}

#
# Deploy KMS Key Alias
#
resource "aws_kms_alias" "k_replica_alias" {
  for_each     = {
    for k, v in var.kms_config:
      k => v if (v["replica"] != null)
  }

  name_prefix   = format("alias/%s-", each.key)
  target_key_id = aws_kms_replica_key.k_replica[each.key].key_id
  provider                = aws.dr
}