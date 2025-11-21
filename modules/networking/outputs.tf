## Azure Networking ID
output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "VNet ID"
}

## Azure AKS Subnet ID
output "aks_subnet_id" {
  value       = azurerm_subnet.aks.id
  description = "AKS subnet ID"
}