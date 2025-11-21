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

## Azure VNet name
variable "vnet_name" {
  description = "VNet name"
  type        = string
}

## Azure VNet address space
variable "vnet_address_space" {
  description = "VNet address space"
  type        = list(string)
}

# Azure AKS Subnet name
variable "aks_subnet_name" {
  description = "AKS subnet name"
  type        = string
}

## Azure AKS subnet CIDR prefix
variable "aks_subnet_prefix" {
  description = "AKS subnet CIDR prefix"
  type        = string
}

## Network Security Group name for AKS subnet
variable "aks_subnet_nsg_name" {
  description = "NSG name for the AKS subnet"
  type        = string
}