locals {
  kv_workflow_name = var.kv_workflow_name
  kv_workflow_rg   = var.kv_workflow_rg
}

data "azurerm_key_vault" "sqlhstkv" {
  count = var.kv_workflow_enable ? 1 : 0

  name                = local.kv_workflow_name
  resource_group_name = local.kv_workflow_rg
}

data "azurerm_key_vault_secret" "sqlhstsvc" {
  count = var.kv_workflow_enable ? 1 : 0

  name         = "sqlhstsvc"
  key_vault_id = data.azurerm_key_vault.sqlhstkv[count.index].id
}

data "azurerm_key_vault_secret" "saloggingname" {
  count = var.kv_workflow_enable ? 1 : 0

  name         = "saloggingname"
  key_vault_id = data.azurerm_key_vault.sqlhstkv[count.index].id
}

data "azurerm_storage_account" "saloggingname" {
  count = var.kv_workflow_enable ? 1 : 0

  name                = data.azurerm_key_vault_secret.saloggingname[count.index].value
  resource_group_name = var.kv_workflow_salogging_rg
}

data "azurerm_virtual_network" "pgsql" {
  count = var.vnet_enable ? 0 : 1

  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

data "azurerm_subnet" "pgsql" {
  count = var.subnet_enable ? 0 : 1

  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}
