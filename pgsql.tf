# Azure Database for PostgreSQL - Flexible Server

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

  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  administrator_login    = var.administrator_login
  administrator_password = (var.kv_pointer_enable && length(data.azurerm_key_vault_secret.pointer_sqladmin_password) > 0) ? data.azurerm_key_vault_secret.pointer_sqladmin_password[0].value : var.administrator_password

  sku_name   = var.sku_name
  version    = var.pgsql_version
  storage_mb = var.storagesize_mb

  backup_retention_days        = 35
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  zone                         = 1

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
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
resource "azurerm_postgresql_flexible_server_configuration" "client_min_messages" {
  name      = "client_min_messages"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.client_min_messages
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "debug_print_parse" {
  name      = "debug_print_parse"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.debug_print_parse
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "debug_print_plan" {
  name      = "debug_print_plan"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.debug_print_plan
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "debug_print_rewritten" {
  name      = "debug_print_rewritten"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.debug_print_rewritten
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "log_checkpoints" {
  name      = "log_checkpoints"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.log_checkpoints
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "log_duration" {
  name      = "log_duration"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.log_duration
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "log_error_verbosity" {
  name      = "log_error_verbosity"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.log_error_verbosity
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "log_lock_waits" {
  name      = "log_lock_waits"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.log_lock_waits
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "log_min_duration_statement" {
  name      = "log_min_duration_statement"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.log_min_duration_statement
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "log_min_error_statement" {
  name      = "log_min_error_statement"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.log_min_error_statement
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "log_min_messages" {
  name      = "log_min_messages"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.log_min_messages
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "log_statement" {
  name      = "log_statement"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.log_statement
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "row_security" {
  name      = "row_security"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.row_security
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "checkpoint_warning" {
  name      = "checkpoint_warning"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.checkpoint_warning
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "connection_throttling" {
  name      = "connection_throttle.enable"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.connection_throttling
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "maintenance_work_mem" {
  name      = "maintenance_work_mem"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.maintenance_work_mem
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "min_wal_size" {
  name      = "min_wal_size"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.min_wal_size
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "max_wal_size" {
  name      = "max_wal_size"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.max_wal_size
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "pg_stat_statements_track_utility" {
  name      = "pg_stat_statements.track_utility"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.pg_stat_statements_track_utility
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "pg_qs_track_utility" {
  name      = "pg_qs.track_utility"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.pg_qs_track_utility
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "pg_qs_query_capture_mode" {
  name      = "pg_qs.query_capture_mode"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.pg_qs_query_capture_mode
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "pgms_wait_sampling_query_capture_mode" {
  name      = "pgms_wait_sampling.query_capture_mode"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.pgms_wait_sampling_query_capture_mode
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "temp_buffers" {
  name      = "temp_buffers"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.temp_buffers
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "wal_buffers" {
  name      = "wal_buffers"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.wal_buffers
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "wal_writer_delay" {
  name      = "wal_writer_delay"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.wal_writer_delay
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "wal_writer_flush_after" {
  name      = "wal_writer_flush_after"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.wal_writer_flush_after
}

# Sets a PostgreSQL Configuration value on a Azure PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration
#
resource "azurerm_postgresql_flexible_server_configuration" "work_mem" {
  name      = "work_mem"
  server_id = azurerm_postgresql_flexible_server.pgsql.id
  value     = var.work_mem
}
