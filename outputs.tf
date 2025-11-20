# AKS FQDN Output
output "aks_fqdn" {
  value       = azurerm_kubernetes_cluster.aks.fqdn
  description = "AKS API server FQDN"
}

# Kubeconfig Output
output "aks_kube_config" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "Kubeconfig for the AKS cluster"
}

#ACR Name
output "acr_name" {
  value       = azurerm_container_registry.acr.name
  description = "Name of the Azure Container Registry"
}

#Key Vault Name
output "key_vault_name" {
  value       = azurerm_key_vault.kv.name
  description = "Name of the Azure Key Vault"
}

#Key Vault Resource ID
output "key_vault_id" {
  value       = azurerm_key_vault.kv.id
  description = "Resource ID of the Azure Key Vault"
}