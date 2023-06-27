locals {
  kms_config = {

    opsteam-test-dyngrant-001 = {}
    opsteam-test-dyngrant-002 = {
      grant = [
        {
          grantee_principal = "arn:aws:iam::770831555164:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"
        }
      ]
    }

  }
}

module "kms" {
  source = "../.."
  kms_config = {
    for k,v in local.kms_config:
      k => v
  }
}

output "name" {
  value = module.kms.name
}