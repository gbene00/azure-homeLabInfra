
## Resource Modules
module "resources" {
  source = "./modules/resources"

  names         = var.names
  location      = var.location
  acr_sku       = var.acr_sku
  key_vault_sku = var.key_vault_sku
}

### Networking Module
module "networking" {
  source = "./modules/networking"

  location           = var.location
  resource_group_name = module.resources.resource_group_name
  vnet_name          = var.names.vnet
  vnet_address_space = var.vnet_address_space
  aks_subnet_name    = var.names.aks_subnet
  aks_subnet_prefix  = var.aks_subnet_prefix
}

### Compute Module
module "compute" {
  source = "./modules/compute"

  location            = var.location
  resource_group_name = module.resources.resource_group_name

  aks_name    = var.names.aks
  dns_prefix  = var.names.dns_prefix
  aks_sku_tier = var.aks_sku_tier

  kubernetes_version = var.kubernetes_version

  subnet_id = module.networking.aks_subnet_id

  service_cidr   = var.service_cidr
  dns_service_ip = var.dns_service_ip

  system_node_pool = var.system_node_pool
  user_node_pools  = var.user_node_pools

  acr_id       = module.resources.acr_id
  key_vault_id = module.resources.key_vault_id
  storage_account_id = module.resources.storage_account_id
}