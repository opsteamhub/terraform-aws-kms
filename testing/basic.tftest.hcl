mock_provider "aws" {}

mock_provider "aws" {
  alias = "dr"
}

run "secure_primary_key" {
  command = plan

  variables {
    kms_config = {
      eks = {
        description  = "EKS encryption"
        multi_region = false
        tags = {
          Environment = "test"
          Project     = "terraform-modules"
          Owner       = "platform"
        }
      }
    }
  }

  assert {
    condition     = aws_kms_key.k["eks"].enable_key_rotation
    error_message = "KMS rotation must remain enabled by default."
  }

  assert {
    condition     = aws_kms_key.k["eks"].description == "EKS encryption"
    error_message = "The configured description must be used."
  }

  assert {
    condition     = aws_kms_key.k["eks"].tags["Owner"] == "platform"
    error_message = "Mandatory tags must reach the key."
  }
}

run "plans_multiple_grants" {
  command = plan

  variables {
    kms_config = {
      application = {
        tags = {
          Environment = "test"
          Project     = "terraform-modules"
          Owner       = "platform"
        }
        grant = [
          {
            name              = "reader"
            grantee_principal = "arn:aws:iam::123456789012:role/reader"
          },
          {
            name              = "writer"
            grantee_principal = "arn:aws:iam::123456789012:role/writer"
          }
        ]
      }
    }
  }

  assert {
    condition     = length(aws_kms_grant.k_grant_by_count) == 2
    error_message = "Every configured grant must create a distinct resource instance."
  }
}

run "rejects_missing_tags" {
  command = plan

  variables {
    kms_config = {
      invalid = {}
    }
  }

  expect_failures = [var.kms_config]
}

run "rejects_replica_without_region" {
  command = plan

  variables {
    kms_config = {
      invalid = {
        tags = {
          Environment = "test"
          Project     = "terraform-modules"
          Owner       = "platform"
        }
        replica = {}
      }
    }
  }

  expect_failures = [var.kms_config]
}

run "plans_replica_with_region_without_credentials" {
  command = plan

  variables {
    disaster_recovery_region = "us-west-2"
    kms_config = {
      replicated = {
        tags = {
          Environment = "test"
          Project     = "terraform-modules"
          Owner       = "platform"
        }
        replica = {}
      }
    }
  }

  assert {
    condition = (
      length(aws_kms_replica_key.k_replica) == 1 &&
      length(aws_kms_alias.k_replica_alias) == 1 &&
      aws_kms_replica_key.k_replica["replicated"].tags["Owner"] == "platform"
    )
    error_message = "The DR provider must plan a replica and alias without AWS credentials."
  }
}
