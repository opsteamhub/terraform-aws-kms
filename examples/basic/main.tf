terraform {
  required_version = ">= 1.7.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0, < 7.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "kms" {
  source = "../.."

  kms_config = {
    example = {
      description  = "Example application key"
      multi_region = false
      tags = {
        Environment = "example"
        Project     = "terraform-modules"
        Owner       = "platform"
      }
    }
  }
}
