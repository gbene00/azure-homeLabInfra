data "azurerm_client_config" "current" {}

## Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.names.rg
  location = var.location
}

## Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.names.acr
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku           = var.acr_sku
  admin_enabled = true

  depends_on = [azurerm_resource_group.rg]
}

## Azure Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                = var.names.kv
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = var.key_vault_sku

  soft_delete_retention_days     = 7
  purge_protection_enabled       = false
  public_network_access_enabled  = true
  rbac_authorization_enabled     = true

  depends_on = [azurerm_resource_group.rg]
}

## Azure Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = var.names.sa
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # You can tweak these as you like later
  min_tls_version             = "TLS1_2"
  public_network_access_enabled = true

  depends_on = [azurerm_resource_group.rg]
}