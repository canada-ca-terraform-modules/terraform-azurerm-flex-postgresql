##############################
### User Assigned Identity ###
##############################

# Manages a User Assigned Identity.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
#
resource "azurerm_user_assigned_identity" "pgsql" {
  name                = "${var.name}-db-msi"
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags
}

####################################
### Managed PostgreSQL for Azure ###
####################################

# Manages a PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server
#
resource "azurerm_postgresql_flexible_server" "pgsql" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group

  delegated_subnet_id = var.delegated_subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  administrator_login    = var.administrator_login
  administrator_password = (var.kv_pointer_enable && length(data.azurerm_key_vault_secret.pointer_sqladmin_password) > 0) ? data.azurerm_key_vault_secret.pointer_sqladmin_password[0].value : var.administrator_password

  sku_name   = var.sku_name
  version    = var.pgsql_version
  storage_mb = var.storagesize_mb

  authentication {
    active_directory_auth_enabled = true
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.pgsql.id]
  }

  customer_managed_key {
    key_vault_key_id                  = azurerm_key_vault_key.cmk.id
    primary_user_assigned_identity_id = azurerm_user_assigned_identity.pgsql.id
  }

  backup_retention_days        = 35
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  zone                         = 1

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags,
      zone
    ]
  }
}

# Manages a PostgreSQL Flexible Server.
#
# Allows you to set a user or group as the AD administrator for a PostgreSQL Flexible Server.
#
resource "azurerm_postgresql_flexible_server_active_directory_administrator" "pgsql" {
  count = length(var.active_directory_administrator)

  server_name         = azurerm_postgresql_flexible_server.pgsql.name
  resource_group_name = var.resource_group

  tenant_id      = data.azurerm_client_config.current.tenant_id
  object_id      = var.active_directory_administrator[count.index].object_id
  principal_name = var.active_directory_administrator[count.index].principal_name
  principal_type = var.active_directory_administrator[count.index].principal_type
}

# Manages a PostgreSQL Flexible Server Database.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database
#
resource "azurerm_postgresql_flexible_server_database" "pgsql" {
  for_each  = var.databases
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  charset   = lookup(each.value, "charset", "utf8")
  collation = lookup(each.value, "collation", "en_US.utf8")
}

# Manages a PostgreSQL Flexible Server Firewall Rule.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_firewall_rule
#
resource "azurerm_postgresql_flexible_server_firewall_rule" "pgsql" {
  for_each         = toset(var.firewall_rules)
  name             = replace(each.key, ".", "-")
  server_id        = azurerm_postgresql_flexible_server.pgsql.id
  start_ip_address = each.key
  end_ip_address   = each.key
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "pgsql" {
  for_each  = var.postgresql_configurations
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = each.value
}

# The postgresql_extension resource creates and manages an extension on a PostgreSQL server.
#
# https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_extension
#
resource "postgresql_extension" "pgcrypto" {
  for_each     = var.databases
  provider     = postgresql
  name         = "pgcrypto"
  database     = azurerm_postgresql_flexible_server_database.pgsql[each.key].name
  drop_cascade = true
}
