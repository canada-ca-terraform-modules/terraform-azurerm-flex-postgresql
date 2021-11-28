output "id" {
  value = azurerm_postgresql_flexible_server.pgsql.id
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.pgsql.fqdn
}

output "administrator_login" {
  value = azurerm_postgresql_flexible_server.pgsql.administrator_login
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.private_dns_zone.id
}

output "subnet_id" {
  value = var.vnet_create ? azurerm_subnet.pgsql[0].id : data.azurerm_subnet.pgsql[0].id
}

output "virtual_network_id" {
  value = var.vnet_create ? azurerm_virtual_network.pgsql[0].id : data.azurerm_virtual_network.pgsql[0].id
}
