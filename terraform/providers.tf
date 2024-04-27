provider "aws" {
  region  = local.aws_config.region
  profile = "se15"
}

provider "aws" {
  alias   = "route53"
  profile = "demosales"
  region  = local.aws_config.region
}


provider "aws" {
  alias   = "personal"
  profile = "personal"
  region  = local.aws_config.region
}

provider "azurerm" {
  features {}
}

variable "aws_config" {
  type        = string
  description = "aws config file"
  default     = "config-files/aws-se15-us-east-2.yaml"
}

variable "azure_config" {
  type        = string
  description = "azure config file"
  default     = "config-files/azure-se15-east-us.yaml"
}
