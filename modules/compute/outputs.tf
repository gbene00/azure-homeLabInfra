## Azure AKS Cluster ID
output "aks_id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "AKS cluster ID"
}

## Azure AKS Cluster FQDN
output "aks_fqdn" {
  value       = azurerm_kubernetes_cluster.aks.fqdn
  description = "AKS API server FQDN"
}

## Azure AKS Kubeconfig
output "aks_kube_config" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "Kubeconfig for the AKS cluster"
}