#
# Define KMS policy to be attached embedded to the Key.
#
data "aws_iam_policy_document" "kms-policy" {
  for_each = {  for k, v in var.kms_config:
    k => v if v["policy"] != null
  }
 
  dynamic "statement" {
    for_each = each.value["policy"]

    content {
      actions = statement.value["actions"]
      
      dynamic "condition" {
        for_each = coalesce(statement.value["condition"], [])
        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = condition.value["values"]
        }
      }
      
      effect  = statement.value["effect"]
      not_actions = statement.value["not_actions"]
      
      dynamic "not_principals" {
        for_each = coalesce(statement.value["not_principals"], [])
        content {
          type        = not_principals.value["type"]
          identifiers = not_principals.value["identifiers"]  
        }
      }

      not_resources = statement.value["not_resources"]

      dynamic "principals" {
        for_each = coalesce(statement.value["principals"], [])
        content {
          type        = principals.value["type"]
          identifiers = principals.value["identifiers"]  
        }
      }

      resources = statement.value["resources"]

      sid = statement.value["sid"]
    }
  } 
}

#
# Define KMS policy to be attached embedded to the Replica Key.
#
data "aws_iam_policy_document" "kms-replica-policy" {
  for_each = {  for k, v in var.kms_config:
    k => v["replica"] if try(v["replica"]["policy"], null) != null
  }
 
  dynamic "statement" {
    for_each = each.value["policy"]

    content {
      actions = statement.value["actions"]
      
      dynamic "condition" {
        for_each = coalesce(statement.value["condition"], [])
        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = condition.value["values"]
        }
      }
      
      effect  = statement.value["effect"]
      not_actions = statement.value["not_actions"]
      
      dynamic "not_principals" {
        for_each = coalesce(statement.value["not_principals"], [])
        content {
          type        = not_principals.value["type"]
          identifiers = not_principals.value["identifiers"]  
        }
      }

      not_resources = statement.value["not_resources"]

      dynamic "principals" {
        for_each = coalesce(statement.value["principals"], [])
        content {
          type        = principals.value["type"]
          identifiers = principals.value["identifiers"]  
        }
      }

      resources = statement.value["resources"]

      sid = statement.value["sid"]
    }
  }
}