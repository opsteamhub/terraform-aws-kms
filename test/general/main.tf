module "kms" {
  source = "../.."

  kms_config = {
    #opsteam-teste-001 = {
    #  create = false
    #}

    opsteam-teste-001 = {
    }
    ##opsteam-teste-002 = {
    ##  #replica = {
    ##  #  replica_region = "us-west-2"
    ##  #}
    ##  grant = [
    ##    {
    ##      grantee_principal = "arn:aws:iam::770831555164:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"
    ##    }
    ##  ]
    ##  policy = [
    ##    {
    ##      sid = "Enable IAM User Permissions"
    ##      effect = "Allow"
    ##      principals = [
    ##        {
    ##          type = "AWS"
    ##          identifiers = ["arn:aws:iam::770831555164:root"]
    ##        }
    ##      ]
    ##      actions = ["kms:*"]
    ##      resources = ["*"]
    ##    }
    ##  ]
    ##}
  }
}


module "kms_replica" {
  source = "../.."

  disaster_recovery_region = module.dr_region.dr_region
  kms_config = {
    opsteam-teste-030 = {
      replica = {
      }
    }
  }
}

module "dr_region" {
  source = "../../../terraform-aws-dr-region"
}