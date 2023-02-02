# Data Sources

data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "pointer" {
  count = var.kv_pointer_enable ? 1 : 0

  name                = var.kv_pointer_name
  resource_group_name = var.kv_pointer_rg
}

data "azurerm_key_vault_secret" "pointer_sqladmin_password" {
  count = var.kv_pointer_enable ? 1 : 0

  name         = var.kv_pointer_sqladmin_password
  key_vault_id = data.azurerm_key_vault.pointer[count.index].id
}

data "azurerm_monitor_diagnostic_categories" "postgresql_server" {
  count = (var.diagnostics != null) ? 1 : 0

  resource_id = azurerm_postgresql_flexible_server.pgsql.id
}
