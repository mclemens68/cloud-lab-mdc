provider "azurerm" {
  features {}
}
variable "azure_config" {
  type        = string
  description = "azure config file"
  default     = "azure-se32-east-us.yaml"
}
