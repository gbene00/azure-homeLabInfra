## Resource Group name
output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Resource group name"
}

## Resource Group ID
output "resource_group_id" {
  value       = azurerm_resource_group.rg.id
  description = "Resource group ID"
}

## Azure Container Registry
output "acr_id" {
  value       = azurerm_container_registry.acr.id
  description = "ACR resource ID"
}

## Azure Container Registry Name
output "acr_name" {
  value       = azurerm_container_registry.acr.name
  description = "ACR name"
}

## Azure Key Vault
output "key_vault_id" {
  value       = azurerm_key_vault.key_vault.id
  description = "Key Vault resource ID"
}

## Azure Key Vault Name
output "key_vault_name" {
  value       = azurerm_key_vault.key_vault.name
  description = "Key Vault name"
}