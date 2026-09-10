variable "disaster_recovery_region" {
  description = "Configure one Region to be the Remote Zone to replicate the KMS Keys. Mandatory if you need to Replicate your keys."
  type        = string
  default     = null
}

variable "kms_config" {
  description = "Define the KMS configurations"
  type = map(
    object(
      {
        replica = optional(
          object(
            {
              bypass_policy_lockout_safety_check = optional(bool, false)
              deletion_window_in_days            = optional(number, 30)
              enabled                            = optional(bool, true)
              policy = optional(
                set(
                  object(
                    {
                      actions = optional(set(string))
                      condition = optional(
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
                      effect      = optional(string, "Deny")
                      not_actions = optional(set(string))
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
                      not_resources = optional(set(string))
                      principals = optional(
                        set(
                          object(
                            {
                              identifiers = optional(set(string))
                              type        = optional(string)
                            }
                          )
                        )
                      )
                      resources = optional(set(string))
                      sid       = optional(string)
                    }
                  )
                )
              )
              tags = optional(map(string))
            }
          )
        )
        bypass_policy_lockout_safety_check = optional(bool, false)
        custom_key_store_id                = optional(string)
        customer_master_key_spec           = optional(string)
        create                             = optional(bool, true)
        deletion_window_in_days            = optional(number, 30)
        description                        = optional(string)
        enable_key_rotation                = optional(bool, true)
        grant = optional(
          list(
            object(
              {
                constraints = optional(
                  object(
                    {
                      encryption_context_equals = optional(map(string), {})
                      encryption_context_subset = optional(map(string), {})
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
        is_enabled   = optional(bool, true)
        key_usage    = optional(string, "ENCRYPT_DECRYPT")
        multi_region = optional(bool, true)
        policy = optional(
          set(
            object(
              {
                actions = optional(set(string))
                condition = optional(
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
                effect      = optional(string, "Deny")
                not_actions = optional(set(string))
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
                not_resources = optional(set(string))
                principals = optional(
                  set(
                    object(
                      {
                        identifiers = optional(set(string))
                        type        = optional(string)
                      }
                    )
                  )
                )
                resources = optional(set(string))
                sid       = optional(string)
              }
            )
          )
        )
        tags = optional(map(string))
      }
    )
  )

  validation {
    condition = alltrue([
      for config in values(var.kms_config) :
      !config.create || length(setsubtract(toset(["Environment", "Project", "Owner"]), toset(keys(coalesce(config.tags, {}))))) == 0
    ])
    error_message = "Every KMS key must include Environment, Project, and Owner in tags."
  }

  validation {
    condition = alltrue([
      for config in values(var.kms_config) :
      config.deletion_window_in_days >= 7 && config.deletion_window_in_days <= 30
    ])
    error_message = "deletion_window_in_days must be between 7 and 30."
  }

  validation {
    condition = alltrue([
      for config in values(var.kms_config) :
      config.replica == null || (config.create && config.multi_region && var.disaster_recovery_region != null)
    ])
    error_message = "Replica keys require create = true, multi_region = true, and disaster_recovery_region."
  }

  validation {
    condition = alltrue(flatten([
      for config in values(var.kms_config) : [
        for grant in coalesce(config.grant, []) : grant.grantee_principal != null
      ]
    ]))
    error_message = "Every KMS grant must set grantee_principal."
  }
}
