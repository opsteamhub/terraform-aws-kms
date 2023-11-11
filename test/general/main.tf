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


#provider "aws" {
#  alias = "dr"
#  region = "us-west-2"
#}

#
# Defining the DR Region
#
#xresource "random_shuffle" "backup_dr_region" {
#x  input        = setsubtract(data.aws_regions.regions.names, toset([data.aws_region.session.name]))
#x  result_count = 1
#x}


##provider "aws" {
##  alias = "dr"
##  region = "us-west-2"
##}


##
## Retrieve Session Main Region
##
#data "aws_region" "session" {}
#
##
## Get the list of available Regions
##
#data "aws_regions" "regions" {
#  all_regions = true
#  filter {
#    name   = "opt-in-status"
#    values = ["opt-in-not-required"]
#  }
#}
#
##
## Defining the DR Region
##
#resource "random_shuffle" "backup_dr_region" {
#  input        = setsubtract(data.aws_regions.regions.names, toset([data.aws_region.session.name]))
#  result_count = 1
#}




#
# Provider setting 
#
#provider "aws" {
#  region = coalesce(
#    var.kms_config["replica"]["replica_region"],
#    element(
#      random_shuffle.backup_dr_region.result,
#      0
#    )
#  )
#  alias  = "dr"
#}


#output "a" {
#  value = element(
#    random_shuffle.backup_dr_region.result,
#    0
#  )
#}