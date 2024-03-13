#####################
### Prerequisites ###
#####################

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias = "dns_zone_provider"
}

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
  sa_create_log = true
  sa_subnet_ids = []

  environment = "dev"
  project     = ""

  tags = {
    "tier" = "k8s"
  }

  providers = {
    azurerm                   = azurerm
    azurerm.dns_zone_provider = azurerm.dns_zone_provider
  }
}
