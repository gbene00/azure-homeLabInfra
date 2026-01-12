## Global names (RG, AKS, ACR, VNet, Subnet, Key Vault, DNS prefix)
variable "names" {
  description = "Logical names for core resources"
  type = object({
    rg         = string
    aks        = string
    acr        = string
    vnet       = string
    aks_subnet = string
    dns_prefix = string
    kv         = string
    sa         = string
  })
  default = {
    rg         = "homelab-rg"
    aks        = "aks-engine-homelab"
    acr        = "gbenehomelabacr"
    vnet       = "homelab-vnet"
    aks_subnet = "aks-engine-subnet"
    dns_prefix = "aks-engine-homelab"
    kv         = "gbenehomelab-kv"
    sa         = "homelabstorage100"
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

## AKS subnet CIDR
variable "aks_subnet_prefix" {
  description = "CIDR for the AKS subnet"
  type        = string
  default     = "10.0.0.0/22"
}

## AKS service CIDR
variable "service_cidr" {
  description = "CIDR for AKS services"
  type        = string
  default     = "10.1.0.0/16"
}

## AKS DNS service IP
variable "dns_service_ip" {
  description = "DNS IP inside the AKS service CIDR"
  type        = string
  default     = "10.1.0.10"
}

## AKS version & tier
variable "kubernetes_version" {
  description = "AKS Kubernetes version for automatic upgrades"
  type        = string
  default     = null
}

## AKS automatic upgrade settings
variable "automatic_upgrade_channel" {
  description = "Automatic upgrade channel for AKS"
  type        = string
  default     = "stable"
}

## AKS node OS upgrade channel
variable "node_os_upgrade_channel" {
  description = "Channel for automatic node OS image upgrades (None, NodeImage, SecurityPatch)"
  type        = string
  default     = "SecurityPatch"
}

## Max surge for AKS node pool upgrades
variable "node_pool_max_surge" {
  description = "Max surge value during AKS node pool upgrades (percentage or absolute number)"
  type        = string
  default     = "33%"
}

variable "aks_sku_tier" {
  description = "AKS pricing tier"
  type        = string
  default     = "Free"
}

## Azure Container Registry SKU
variable "acr_sku" {
  description = "SKU for the Azure Container Registry"
  type        = string
  default     = "Standard"
}

## Key Vault SKU
variable "key_vault_sku" {
  description = "SKU for Azure Key Vault"
  type        = string
  default     = "standard"
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
    min_count = 2
    max_count = 3
  }
}

variable "system_extra_pool" {
  description = "Additional system node pool"
  type = object({
    name      = string
    vm_size   = string
    min_count = number
    max_count = number
    max_pods  = number
  })
  default = {
    name      = "syspool"
    vm_size   = "Standard_D4ps_v6"
    min_count = 2
    max_count = 3
    max_pods  = 70
  }
}

## User node pool
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

## Storage Container Names
variable "storage_containers" {
  description = "Blob containers for backups and database dumps"
  type = object({
    velero   = string
    pg_dumps = string
  })

  default = {
    velero   = "velero-backups"
    pg_dumps = "pgsql-dumps"
  }
}

