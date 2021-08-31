resource "azurerm_virtual_network" "pgsql" {
  count = var.vnet_enable ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = var.vnet_cidr
}

resource "azurerm_subnet" "pgsql" {
  count = var.subnet_enable ? 1 : 0

  name                 = var.name
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet_enable ? azurerm_virtual_network.pgsql[0].name : data.azurerm_virtual_network.pgsql[0].name
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
  virtual_network_id    = var.vnet_enable ? azurerm_virtual_network.pgsql[0].id : data.azurerm_virtual_network.pgsql[0].id
  resource_group_name   = var.resource_group
}
