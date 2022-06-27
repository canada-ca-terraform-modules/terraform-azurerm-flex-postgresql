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

#########################################################
# vnet_create (used for storage account network rule)
# => ``null` then no vnet created or attached (default)
# => ``true` then enable creation of new vnet
# => ``false` then point to existing vnet
#########################################################

data "azurerm_virtual_network" "pgsql" {
  count = (var.vnet_create == false) ? 1 : 0

  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

data "azurerm_subnet" "pgsql" {
  count = (var.vnet_create == false) ? 1 : 0

  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}
