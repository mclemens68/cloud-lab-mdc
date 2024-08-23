variable "se_account" {
  type        = string
  description = "Individual SE account"
}
variable "domain" {
  type        = string
  description = "Domain"
}
variable "sshkey" {
  type        = string
  description = "Base name of SSH key files"
  default     = "id_rsa"
}
variable "admin_cidr_list" {
  description = "List of CIDR blocks for admin access"
  type        = list(string)
  default     = []
}