module "kms" {
  source = "../.."
  kms_config = {
    opsteam-teste-001 = {
      create = false
    }

    opsteam-teste-001 = {}
    opsteam-teste-002 = {
      grant = [
        {
          grantee_principal = "arn:aws:iam::770831555164:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"
        }
      ]
      policy = [
        {
          sid = "Enable IAM User Permissions"
          effect = "Allow"
          principals = [
            {
              type = "AWS"
              identifiers = ["arn:aws:iam::770831555164:root"]
            }
          ]
          actions = ["kms:*"]
          resources = ["*"]
        }
      ]
    }
  }
}
