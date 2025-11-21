## Resource Group name
output "resource_group_name" {
  value       = module.resources.resource_group_name
  description = "Name of the resource group"
}

## AKS Cluster FQDN
output "aks_fqdn" {
  value       = module.compute.aks_fqdn
  description = "AKS API server FQDN"
}

## AKS Kubeconfig
output "aks_kube_config" {
  value       = module.compute.aks_kube_config
  sensitive   = true
  description = "Kubeconfig for the AKS cluster"
}

## Azure Container Registry Name
output "acr_name" {
  value       = module.resources.acr_name
  description = "Name of the Azure Container Registry"
}

## Azure Key Vault Name
output "key_vault_name" {
  value       = module.resources.key_vault_name
  description = "Name of the Azure Key Vault"
}