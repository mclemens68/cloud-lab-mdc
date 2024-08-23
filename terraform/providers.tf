provider "aws" {
  region  = local.aws_config.region
  profile = "${var.se_account}"
}

#provider "aws" {
#  alias   = "route53"
#  profile = "demosales"
#  region  = local.aws_config.region
#}


provider "aws" {
  alias   = "personal"
  profile = "personal"
  region  = local.aws_config.region
}

provider "azurerm" {
  features {}
}
