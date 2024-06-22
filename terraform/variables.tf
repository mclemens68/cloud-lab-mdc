variable "se_account" {
  type        = string
  description = "Individual SE account"
}
variable "domain" {
  type        = string
  description = "Domain"
}
variable "az-rg" {
  type        = string
  description = "Azure Resource Group"
}
variable "admin_cidr_list" {
  description = "List of CIDR blocks for admin access"
  type        = list(string)
  default     = []
}