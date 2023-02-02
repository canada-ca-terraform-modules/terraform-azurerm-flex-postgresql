#################
### Key Vault ###
#################

# Manages a Key Vault.
#
# https://gitlab.k8s.cloud.statcan.ca/cloudnative/platform/terraform/terraform-azure-key-vault.git
#
module "enc_key_vault" {
  source = "git::https://gitlab.k8s.cloud.statcan.ca/cloudnative/platform/terraform/terraform-azure-key-vault.git?ref=v1.1.0"

  prefix              = "${var.name}-enc"
  resource_group_name = var.resource_group

  sku_name                   = "premium"
  purge_protection_enabled   = true
  soft_delete_retention_days = 90

  public_network_access_enabled = false
  private_endpoints = [
    {
      subnet_id = var.subnet_id
    }
  ]

  tags = var.tags

  providers = {
    azurerm                   = azurerm
    azurerm.dns_zone_provider = azurerm.dns_zone_provider
  }
}

# Manages a Key Vault Key.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key
#
resource "azurerm_key_vault_key" "cmk" {
  name         = "${var.name}-key-cmk"
  key_vault_id = module.enc_key_vault.id

  # Use an HSM-backed key
  key_type = "RSA-HSM"

  # Key size of 2048 is required for Flexible Server for PostgreSQL
  # https://learn.microsoft.com/en-us/azure/postgresql/single-server/concepts-data-encryption-postgresql#limitations
  key_size = "2048"

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

############################
### RBAC & Access Policy ###
############################

# Allow the disk encryption set to access to the Key Vault key
resource "azurerm_key_vault_access_policy" "cmk" {
  key_vault_id = module.enc_key_vault.id
  tenant_id    = azurerm_user_assigned_identity.pgsql.tenant_id
  object_id    = azurerm_user_assigned_identity.pgsql.principal_id

  key_permissions = [
    "Get",
    "List",
    "UnwrapKey",
    "WrapKey",
  ]
}
