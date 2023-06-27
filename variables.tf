variable kms_config {
  description = "value"
  type = map(
    object(
      {
        bypass_policy_lockout_safety_check = optional(bool, false)
        custom_key_store_id                = optional(string)
        customer_master_key_spec           = optional(string)
        create                             = optional(bool, true)
        deletion_window_in_days            = optional(string, 30)
        description                        = optional(string)
        enable_key_rotation                = optional(bool, true)
        grant = optional(
          list(
            object(
              {
                constraints = optional(
                  object(
                    {
                      encryption_context_equals = set(string)
                      encryption_context_subset = set(string)
                    }
                  )
                )
                grant_creation_tokens = optional(set(string)) 
                grantee_principal     = optional(string)
                name                  = optional(string)
                operations            = optional(set(string), ["Encrypt", "Decrypt", "GenerateDataKey"])
                retire_on_delete      = optional(bool, false)
                retiring_principal    = optional(string)
              }
            )
          )
        )
        is_enabled                         = optional(bool, true)
        key_usage                          = optional(string, "ENCRYPT_DECRYPT")
        multi_region                       = optional(bool, false)
        policy = optional(
          set(
            object(
              {
                actions        = optional(set(string))
                condition      = optional(
                  set(
                    object(
                      {
                        test     = optional(string)
                        variable = optional(string)
                        values   = optional(set(string))
                      }
                    )
                  )
                )
                effect         = optional(string, "Deny")
                not_actions    = optional(set(string))
                not_principals = optional(
                  set(
                    object(
                      {
                      identifiers = optional(set(string))
                      type        = optional(string)
                      }
                    )
                  )
                )
                not_resources  = optional(set(string))
                principals     = optional(
                  set(
                    object(
                      {
                      identifiers = optional(set(string))
                      type        = optional(string)
                      }
                    )
                  )
                )
                resources      = optional(set(string))
                sid            = optional(string)
              }
            )
          )
        )
        tags                   = optional(map(string))
      }
    )
  )
}