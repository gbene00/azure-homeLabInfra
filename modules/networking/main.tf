## Azure Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
}

## Azure Subnet for AKS
resource "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.aks_subnet_prefix]

  depends_on = [azurerm_virtual_network.vnet]
}

## Azure Network Security Group for AKS Subnet
resource "azurerm_network_security_group" "aks_nsg" {
  name                = var.aks_subnet_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

## Associate NSG to AKS Subnet
resource "azurerm_subnet_network_security_group_association" "aks_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}

## NSG rules for the AKS subnet NSG
resource "azurerm_network_security_rule" "aks_subnet_rules" {
  for_each = { for rule in var.aks_subnet_nsg_rules : rule.name => rule }

  name                       = each.value.name
  priority                   = each.value.priority
  direction                  = each.value.direction
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
}