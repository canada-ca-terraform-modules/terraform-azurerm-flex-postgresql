provider "azurerm" {
  features {}
}

module "postgresql_example" {
  source = "git::https://github.com/canada-ca-terraform-modules/terraform-azurerm-flex-postgresql.git?ref=v4.0.0"

  name = "psqlservername"
  databases = {
    psqlservername1 = { collation = "en_US.utf8" },
    psqlservername2 = { chartset = "utf8" },
    psqlservername3 = { chartset = "utf8", collation = "en_US.utf8" },
    psqlservername4 = {}
  }

  administrator_login    = "psqladmin"
  administrator_password = "pgsql1313"

  sku_name       = "GP_Standard_D4s_v3"
  pgsql_version  = "13"
  storagesize_mb = 262144

  location       = "canadacentral"
  resource_group = "psql-dev-rg"

  ip_rules       = []
  firewall_rules = []

  # Needs to be disabled until the following issue is resolved: https://github.com/MicrosoftDocs/azure-docs/issues/32068
  # diagnostics = {
  #   destination   = ""
  #   eventhub_name = ""
  #   logs          = ["all"]
  #   metrics       = ["all"]
  # }

  tags = {
    "tier" = "k8s"
  }

  ######################################################################
  # kv_pointer_enable (pointers in key vault for secrets state)
  # => ``true` then state from key vault is used for creation
  # => ``false` then state from terraform is used for creation (default)
  ######################################################################
  # kv_pointer_enable            = false
  # kv_pointer_name              = "kvpointername"
  # kv_pointer_rg                = "kvpointerrg"
  # kv_pointer_logging_name      = "saloggingname"
  # kv_pointer_logging_rg        = "saloggingrg"
  # kv_pointer_sqladmin_password = "sqlhstsvc"

  #########################################################
  # vnet_create (used for storage account network rule)
  # => ``null` then no vnet created or attached (default)
  # => ``true` then enable creation of new vnet
  # => ``false` then point to existing vnet
  #########################################################
  # vnet_create = false
  # vnet_cidr   = "172.15.0.0/16"
  # vnet_name   = "psql-vnet"
  # vnet_rg     = "XX-XXXX-XXXX-XXX-XXX"
  # subnet_name   = "psql-subnet"
  # subnet_address_prefixes = ["172.15.8.0/22"]
}
