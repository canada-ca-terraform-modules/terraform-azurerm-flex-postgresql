data "azurerm_client_config" "current" {}

######################################################################
# kv_pointer_enable (pointers in key vault for secrets state)
# => ``true` then state from key vault is used for creation
# => ``false` then state from terraform is used for creation (default)
######################################################################

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

data "azurerm_key_vault_secret" "pointer_logging_name" {
  count = var.kv_pointer_enable ? 1 : 0

  name         = var.kv_pointer_logging_name
  key_vault_id = data.azurerm_key_vault.pointer[count.index].id
}

data "azurerm_storage_account" "pointer_logging_name" {
  count = var.kv_pointer_enable ? 1 : 0

  name                = data.azurerm_key_vault_secret.pointer_logging_name[count.index].value
  resource_group_name = var.kv_pointer_logging_rg
}