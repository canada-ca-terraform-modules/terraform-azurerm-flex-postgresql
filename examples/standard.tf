#####################
### Prerequisites ###
### az.tf         ###

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias = "dns_zone_provider"
}

provider "azurerm" {
  features {}
  alias = "mgmt"
}

### data.tf       ###

data "azurerm_subnet" "back" {
  name                 = "devcc-back"
  resource_group_name  = "network-dev-rg"
  virtual_network_name = "devcc-vnet"
}

data "azurerm_private_dns_zone" "kv" {
  provider            = azurerm.mgmt
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = "network-management-rg"
}

locals {
  subnet_ids = []
}

#####################


###############################
### Managed PostgreSQL for Azure ###
###############################

# Manages a PostgreSQL Flexible Server.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server
#
module "postgresql_example" {
  source = "../"

  name                = "pgsqlservername"
  location            = "canadacentral"
  resource_group_name = "pgsql-dev-rg"

  databases = {
    pgsqlservername1 = { collation = "en_US.utf8" },
    pgsqlservername2 = { chartset = "utf8" },
    pgsqlservername3 = { chartset = "utf8", collation = "en_US.utf8" },
    pgsqlservername4 = {}
  }

  administrator_login    = "pgsqladmin"
  administrator_password = "pgSql1313"

  sku_name       = "GP_Standard_D4ds_v4"
  pgsql_version  = "13"
  storagesize_mb = 262144

  ip_rules       = []
  firewall_rules = []

  diagnostics = {
    destination   = ""
    eventhub_name = ""
    logs          = ["all"]
    metrics       = ["all"]
  }

  ## Keyvault
  environment                   = "dev"
  project                       = "hostingsql"
  public_network_access_enabled = true
  kv_subnet_ids                 = local.subnet_ids
  kv_private_endpoints = [
    {
      subnet_id           = data.azurerm_subnet.back.id
      private_dns_zone_id = data.azurerm_private_dns_zone.kv.id
    }
  ]
  ## Storage Account
  sa_create_log        = true
  sa_subnet_ids        = local.subnet_ids
  storage_account_name = "stndbmahmsamsa"

  tags = {
    "tier" = "k8s"
  }

  providers = {
    azurerm                   = azurerm
    azurerm.dns_zone_provider = azurerm.dns_zone_provider
  }
}
