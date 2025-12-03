
## Azure Kubernetes Service Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_prefix         = var.dns_prefix
  kubernetes_version = var.kubernetes_version
  sku_tier           = var.aks_sku_tier

   key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  ## System-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  ## Local accounts + Kubernetes RBAC
  role_based_access_control_enabled = true
  local_account_disabled            = false

  ## Workload identity
  oidc_issuer_enabled      = true
  workload_identity_enabled = true

  ## AKS system node pool
  default_node_pool {
    name           = var.system_node_pool.name
    vm_size        = var.system_node_pool.vm_size
    type           = "VirtualMachineScaleSets"
    vnet_subnet_id = var.subnet_id

    auto_scaling_enabled = true
    min_count            = var.system_node_pool.min_count
    max_count            = var.system_node_pool.max_count
  }

  ## Azure CNI, network profile
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"

    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }
}

## AKS User Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "usernp" {
  for_each              = var.user_node_pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id

  vm_size        = each.value.vm_size
  mode           = "User"
  os_type        = "Linux"
  vnet_subnet_id = var.subnet_id

  auto_scaling_enabled = true
  min_count            = each.value.min_count
  max_count            = each.value.max_count

  depends_on = [azurerm_kubernetes_cluster.aks]
}

# AKS -> ACR Role integration
resource "azurerm_role_assignment" "aks_to_acr" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

# AKS -> Key Vault Role integration
resource "azurerm_role_assignment" "aks_to_kv" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

# AKS -> Storage Account Role integration
resource "azurerm_role_assignment" "aks_to_storage" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}