provider "aws" {
  region  = local.aws_config.region
  profile = "se32"
}

provider "aws" {
  alias   = "route53"
  profile = "demosales"
  region  = local.aws_config.region
}

provider "azurerm" {
  features {}
}

variable "aws_config" {
  type        = string
  description = "aws config file"
  default     = "aws-se32-us-east-2.yaml"
}

variable "azure_config" {
  type        = string
  description = "azure config file"
  default     = "azure-se32-east-us.yaml"
}
