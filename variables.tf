
variable "rg_name" {
  description = "Name of the resource group"
  type        = string
  default     = "hommelab-rg"
}


variable "location" {
  description = "Azure region"
  type        = string
  default     = "UK South"
}