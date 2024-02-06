provider "aws" {
  region  = local.config.region
  profile = "se32"
}

provider "aws" {
  alias   = "route53"
  profile = "demosales"
  region  = local.config.region
}

variable "config" {
  type        = string
  description = "Config file"
  default = "config.yaml"
}