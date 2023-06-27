
#
#
# Define KMS Grant policy to allow AWS services to use KMS Key.
#
resource "aws_kms_grant" "k_grant" {

  for_each = length(aws_kms_grant.k_grant_by_count) == 0 ? zipmap(
    flatten(
      [
        for k, v in var.kms_config:
          [
            for x in coalesce(
              v["grant"],
              []
            ):
              coalesce(
                x["name"],
                replace(
                  format(
                    "%s||%s",
                    k,
                    regex(
                      "/.*",
                      x["grantee_principal"]
                    )
                  ),
                  "/",
                  ""
                ) 
              )
          ]
      ]
    ),
    flatten(
      [
        for k, v in var.kms_config:
          [
            for x in coalesce(
              v["grant"],
              []
            ):
              merge(
                { key_id = aws_kms_key.k[k].key_id },
                x
              )
          ]
      ]
    )
  ) : {}

  dynamic "constraints" {
    for_each = coalesce(each.value["constraints"], {})
    content {
      encryption_context_equals = constraints.value["encryption_context_equals"]
      encryption_context_subset = constraints.value["encryption_context_subset"]
    }
  }

  grant_creation_tokens = each.value["grant_creation_tokens"]
  grantee_principal     = each.value["grantee_principal"]
  key_id                = each.value["key_id"]
  name                  = each.value["name"] 
  operations            = each.value["operations"]
  retire_on_delete      = each.value["retire_on_delete"]
  retiring_principal    = each.value["retiring_principal"]
  
  depends_on = [ aws_kms_key.k ]
}

locals {
  
  #
  #
  #
  x = flatten(
    [
      for k, v in var.kms_config:
        [
          for x in coalesce(
            v["grant"],
            []
          ):
            coalesce(
              x["name"],
              replace(
                format(
                  "%s||%s",
                  k,
                  regex(
                    "/.*",
                    x["grantee_principal"]
                  )
                ),
                "/",
                ""
              ) 
            )
        ]
    ]
  )

  #
  #
  #
  y = zipmap(
    flatten(
      [
        for k, v in var.kms_config:
          [
            for x in coalesce(
              v["grant"],
              []
            ):
              coalesce(
                x["name"],
                replace(
                  format(
                    "%s||%s",
                    k,
                    regex(
                      "/.*",
                      x["grantee_principal"]
                    )
                  ),
                  "/",
                  ""
                ) 
              )
          ]
      ]
    ),
    flatten(
      [
        for k, v in var.kms_config:
          [
            for x in coalesce(
              v["grant"],
              []
            ):
              merge(
                { key_id = aws_kms_key.k[k].key_id },
                x
              )
          ]
      ]
    )
  )

}

#
# Deploy KMS grants by count. This resource was created to work 
# embedded in other modules, cause for_each from dynamic maps handle 
# error exit.
#
resource "aws_kms_grant" "k_grant_by_count" {
  count =   length(local.x)

  dynamic "constraints" {
    for_each = coalesce(
      local.y[element(local.x,0)]["constraints"], {}
    )
    content {
      encryption_context_equals = constraints.value["encryption_context_equals"]
      encryption_context_subset = constraints.value["encryption_context_subset"]
    }
  }

  grant_creation_tokens = local.y[
    element(local.x,0)
  ]["grant_creation_tokens"]

  grantee_principal = local.y[
    element(local.x,0)
  ]["grantee_principal"]
  
  key_id = aws_kms_key.k[
    replace(
      regex(
        ".+\\|\\|",
        element(
          local.x,
          0
        )
      ),
      "||",
      ""
    )
  ].key_id

  name = local.y[
    element(
      local.x,0
    )
  ]["name"] 

  operations = local.y[
    element(
      local.x,0
    )
  ]["operations"]
  
  retire_on_delete = local.y[
    element(local.x,0)
  ]["retire_on_delete"]

  retiring_principal = local.y[
    element(
      local.x,0
    )
  ]["retiring_principal"]


  lifecycle {
    ignore_changes = [
      name,
      key_id,
      grantee_principal,
      operations,  
      retiring_principal,
      constraints,
      grant_creation_tokens,
      retire_on_delete, 
    ]
  }
}

output "name" {
  value = ""
}