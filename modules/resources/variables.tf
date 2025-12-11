## Resource names RG, ACR, Key Vault
variable "names" {
  description = "Names for resources"
  type = object({
    rg  = string
    acr = string
    kv  = string
    sa  = string
  })
}

## Azure region
variable "location" {
  description = "Azure region"
  type        = string
}

## ACR & Key Vault SKUs
variable "acr_sku" {
  description = "ACR SKU"
  type        = string
}

## Key Vault SKU
variable "key_vault_sku" {
  description = "Key Vault SKU"
  type        = string
}

## Storage Container Names
variable "storage_containers" {
  description = "Storage containers used for velero and DB dumps"
  type = object({
    velero   = string
    pg_dumps = string
  })
}