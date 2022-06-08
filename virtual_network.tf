#########################################################
# vnet_create (used for storage account network rule)
# => ``null` then no vnet created or attached (default)
# => ``true` then enable creation of new vnet
# => ``false` then point to existing vnet
#########################################################

resource "azurerm_virtual_network" "pgsql" {
  count = (var.vnet_create == true) ? 1 : 0

  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "pgsql" {
  count = (var.vnet_create == true) ? 1 : 0

  name                 = var.subnet_name
  resource_group_name  = var.vnet_rg
  virtual_network_name = var.vnet_create ? azurerm_virtual_network.pgsql[0].name : data.azurerm_virtual_network.pgsql[0].name
  address_prefixes     = var.subnet_address_prefixes
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "${var.name}-zone.postgres.database.azure.com"
  resource_group_name = var.resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnet_link" {
  name                  = "${var.name}-link"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = var.vnet_create ? azurerm_virtual_network.pgsql[0].id : data.azurerm_virtual_network.pgsql[0].id
  resource_group_name   = var.resource_group
}
