#
# Provider setting 
#
provider "aws" {
  region = var.disaster_recovery_region
  alias  = "dr"
}