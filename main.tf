resource "azurerm_resource_group" "hommelab_rg" {
  name     = var.rg_name
  location = var.location
}
