## Azure Region
variable "location" {
  description = "Azure region"
  type        = string
}

## Azure Resource Group Name
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

## Azure AKS Cluster Name
variable "aks_name" {
  description = "AKS cluster name"
  type        = string
}

## Azure AKS DNS Prefix
variable "dns_prefix" {
  description = "AKS DNS prefix"
  type        = string
}

## Azure Kubernetes Version
variable "kubernetes_version" {
  description = "AKS Kubernetes version"
  type        = string
}

## Azure AKS API SKU Tier
variable "aks_sku_tier" {
  description = "AKS pricing tier"
  type        = string
}

## Azure AKS Subnet ID
variable "subnet_id" {
  description = "AKS subnet resource ID"
  type        = string
}

## Azure AKS service CIDR
variable "service_cidr" {
  description = "CIDR for AKS services"
  type        = string
}

variable "dns_service_ip" {
  description = "DNS IP for AKS services"
  type        = string
}

variable "system_node_pool" {
  description = "Config for the system node pool"
  type = object({
    name      = string
    vm_size   = string
    min_count = number
    max_count = number
  })
}

variable "user_node_pools" {
  description = "Map of user node pools"
  type = map(object({
    vm_size   = string
    min_count = number
    max_count = number
  }))
}

variable "acr_id" {
  description = "ACR resource ID"
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault resource ID"
  type        = string
}