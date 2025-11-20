## Global names (RG, AKS, ACR, VNet, Subnet)
variable "names" {
  description = "Logical names for core resources"
  type = object({
    rg         = string
    aks        = string
    acr        = string
    vnet       = string
    aks_subnet = string
    dns_prefix = string
  })
  default = {
    rg         = "hommelab-rg"
    aks        = "aks-engine-homelab"
    acr        = "gbenehomelabacr"
    vnet       = "homelab-vnet"
    aks_subnet = "aks-engine-subnet"
    dns_prefix = "aks-engine-homelab"
  }
}

## Azure region
variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

## VNet & subnet CIDRs
variable "vnet_address_space" {
  description = "Address space for the homelab VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_prefix" {
  description = "CIDR for the AKS subnet"
  type        = string
  default     = "10.0.0.0/22"
}

## AKS networking (must NOT overlap vnet_address_space)
variable "service_cidr" {
  description = "CIDR for AKS services"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dns_service_ip" {
  description = "DNS IP inside the AKS service CIDR"
  type        = string
  default     = "10.1.0.10"
}

## AKS version / tier
variable "kubernetes_version" {
  type        = string
  description = "AKS Kubernetes version"
  default     = "1.33.3"
}

variable "aks_sku_tier" {
  description = "AKS pricing tier"
  type        = string
  default     = "Free"
}

## ACR SKU
variable "acr_sku" {
  description = "SKU for the Azure Container Registry"
  type        = string
  default     = "Standard"
}

## System node pool settings
variable "system_node_pool" {
  description = "Config for the system node pool"
  type = object({
    name      = string
    vm_size   = string
    min_count = number
    max_count = number
  })
  default = {
    name      = "systemnp"
    vm_size   = "Standard_D2ps_v6"
    min_count = 1
    max_count = 2
  }
}

## User node pools (for_each friendly)
variable "user_node_pools" {
  description = "Map of user node pools"
  type = map(object({
    vm_size   = string
    min_count = number
    max_count = number
  }))
  default = {
    usernp = {
      vm_size   = "Standard_D2ps_v6"
      min_count = 1
      max_count = 3
    }
  }
}

