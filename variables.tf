
## Resource group name
variable "rg_name" {
  description = "Name of the resource group"
  type        = string
  default     = "hommelab-rg"
}

## Azure region
variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

## AKS version
variable "kubernetes_version" {
  type        = string
  description = "AKS Kubernetes version"
  default     = "1.33.3"
}

