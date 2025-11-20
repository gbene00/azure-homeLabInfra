resource "azurerm_resource_group" "hommelab_rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "homelab_vnet" {
  name                = "homelab-vnet"
  location            = azurerm_resource_group.hommelab_rg.location  
  resource_group_name = azurerm_resource_group.hommelab_rg.name       
  address_space       = ["10.0.0.0/16"]

  depends_on = [ azurerm_resource_group.hommelab_rg ]                
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-engine-subnet"
  resource_group_name  = azurerm_resource_group.hommelab_rg.name      
  virtual_network_name = azurerm_virtual_network.homelab_vnet.name
  address_prefixes     = ["10.0.0.0/22"]
  
  depends_on = [ azurerm_virtual_network.homelab_vnet ]
}

resource "azurerm_container_registry" "acr" {
  name                = "gbenehomelabacr"
  location            = azurerm_resource_group.hommelab_rg.location   
  resource_group_name = azurerm_resource_group.hommelab_rg.name       

  sku           = "Standard"
  admin_enabled = true

  depends_on = [ azurerm_resource_group.hommelab_rg ]                 
}

# AKS Cluster definition
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-engine-homelab"
  location            = azurerm_resource_group.hommelab_rg.location   
  resource_group_name = azurerm_resource_group.hommelab_rg.name       

  dns_prefix         = "aks-engine-homelab"
  kubernetes_version = var.kubernetes_version
  sku_tier           = "Free"

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
    name           = "systemnp"
    vm_size        = "Standard_D2ps_v6"
    type           = "VirtualMachineScaleSets"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id

    auto_scaling_enabled = true 
    min_count           = 1
    max_count           = 2
  }

  # Azure CNI, node subnet only
  network_profile {
    network_plugin    = "azure" 
    load_balancer_sku = "standard"
    service_cidr = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
  }

  # Ensure ACR is created first
  depends_on = [
    azurerm_container_registry.acr
  ]
}


# User Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "usernp" {
  name                  = "usernp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D2ps_v6"
  mode                  = "User"
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id

  auto_scaling_enabled = true 
  min_count           = 1
  max_count           = 3
}

# AKS -> ACR Role
# Give the AKS kubelet identity AcrPull on gbenehomelabacr
resource "azurerm_role_assignment" "aks_to_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    azurerm_container_registry.acr
  ]
}


# Outputs
output "aks_fqdn" {
  value       = azurerm_kubernetes_cluster.aks.fqdn
  description = "AKS API server FQDN"
}

output "aks_kube_config" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "Kubeconfig for the AKS cluster"
}