
# Homelab Resource Group

resource "azurerm_resource_group" "homelab" {
  name     = var.names.rg 
  location = var.location
}

# Homelab Networking
resource "azurerm_virtual_network" "homelab_vnet" {
  name                = var.names.vnet                        
  location            = azurerm_resource_group.homelab.location
  resource_group_name = azurerm_resource_group.homelab.name
  address_space       = var.vnet_address_space                

  depends_on = [azurerm_resource_group.homelab]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.names.aks_subnet                  
  resource_group_name  = azurerm_resource_group.homelab.name
  virtual_network_name = azurerm_virtual_network.homelab_vnet.name
  address_prefixes     = [var.aks_subnet_prefix]             

  depends_on = [azurerm_virtual_network.homelab_vnet]
}


# Homelab ACR
resource "azurerm_container_registry" "acr" {
  name                = var.names.acr 
  location            = azurerm_resource_group.homelab.location
  resource_group_name = azurerm_resource_group.homelab.name

  sku           = var.acr_sku                                
  admin_enabled = true

  depends_on = [azurerm_resource_group.homelab]
}


#Homelab AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.names.aks
  location            = azurerm_resource_group.homelab.location
  resource_group_name = azurerm_resource_group.homelab.name

  dns_prefix         = var.names.dns_prefix
  kubernetes_version = var.kubernetes_version
  sku_tier           = var.aks_sku_tier

  # System-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  # Local accounts + Kubernetes RBAC
  role_based_access_control_enabled = true
  local_account_disabled            = false

  # Workload identity
  oidc_issuer_enabled      = true
  workload_identity_enabled = true

  # Default/system node pool
  default_node_pool {
    name           = var.system_node_pool.name
    vm_size        = var.system_node_pool.vm_size
    type           = "VirtualMachineScaleSets"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id

    auto_scaling_enabled = true
    min_count            = var.system_node_pool.min_count
    max_count            = var.system_node_pool.max_count
  }

  # Azure CNI, node subnet only
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"

    service_cidr   = var.service_cidr 
    dns_service_ip = var.dns_service_ip 
  }

  # Ensure ACR is created first
  depends_on = [
    azurerm_container_registry.acr
  ]
}

# User Node Pools
resource "azurerm_kubernetes_cluster_node_pool" "usernp" {
  for_each              = var.user_node_pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id

  vm_size        = each.value.vm_size
  mode           = "User"
  os_type        = "Linux"
  vnet_subnet_id = azurerm_subnet.aks_subnet.id

  auto_scaling_enabled = true
  min_count            = each.value.min_count
  max_count            = each.value.max_count

  depends_on = [azurerm_kubernetes_cluster.aks]
}


# AKS -> ACR Role
resource "azurerm_role_assignment" "aks_to_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    azurerm_container_registry.acr
  ]
}
