output "id" {
  description = "id of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.pgsql.id
}

output "fqdn" {
  description = "fqdn of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.pgsql.fqdn
}

output "private_dns_zone_id" {
  description = "id of private dns zone of database"
  value       = azurerm_private_dns_zone.private_dns_zone.id
}

output "subnet_id" {
  description = "id of database subnet"
  value       = var.subnet_create ? azurerm_subnet.pgsql[0].id : data.azurerm_subnet.pgsql[0].id
}

output "virtual_network_id" {
  value = var.vnet_create ? azurerm_virtual_network.pgsql[0].id : data.azurerm_virtual_network.pgsql[0].id
}
