provider "azurerm" {
  features {}
}

module "postgresql_example" {
  source = "git::https://github.com/canada-ca-terraform-modules/terraform-azurerm-flex-postgresql.git?ref=master"

  name = "psqlservername"
  databases = {
    psqlservername1 = { collation = "en_US.utf8" },
    psqlservername2 = { chartset = "utf8" },
    psqlservername3 = { chartset = "utf8", collation = "en_US.utf8" },
    psqlservername4 = {}
  }

  administrator_login          = "psqladmin"
  administrator_login_password = "psql1313"

  #########################################################
  # kv_workflow_enable
  # => ``true` then enable storing pointers to secrets in key vault
  # => ``false` then store as default
  #########################################################
  kv_workflow_enable = false
  # kv_workflow_name             = "XXXXX"
  # kv_workflow_rg               = "XX-XXXX-XXXX-XXX-XXX"
  # kv_workflow_salogging_rg     = "XX-XXXX-XXXX-XXX-XXX"

  sku_name       = "GP_Standard_D4s_v3"
  pgsql_version  = "13"
  storagesize_mb = 262144

  location       = "canadacentral"
  resource_group = "psql-dev-rg"

  ip_rules       = []
  firewall_rules = []

  #########################################################
  # vnet_create
  # => ``true` then enable creation of new vnet
  # => ``false` then point to existing vnet
  #########################################################
  vnet_create = false
  # vnet_cidr   = "172.15.0.0/16"
  vnet_name   = "psql-vnet"
  vnet_rg     = "XX-XXXX-XXXX-XXX-XXX"

  #########################################################
  # subnet_create
  # => ``true` then enable creation of new subnet
  # => ``false` then point to existing subnet
  #########################################################
  subnet_create = false
  subnet_name   = "psql-subnet"
  # subnet_address_prefixes = ["172.15.8.0/22"]

  # diagnostics = {
  #   destination   = ""
  #   eventhub_name = ""
  #   logs          = ["all"]
  #   metrics       = ["all"]
  # }

  tags = {
    "tier" = "k8s"
  }
}
