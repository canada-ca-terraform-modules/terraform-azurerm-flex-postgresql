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

data "azurerm_private_dns_zone" "flex_dns_zone" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = "network-management-rg"
  provider            = azurerm.dns_zone_provider
}

locals {
  subnet_ids = []
}

#####################
# These variables can have their values set as CI/CD Variables with the names TF_VAR_PG_Admin_Username and TF_VAR_PG_Admin_Password.

variable "PG_Admin_Username" {
  type        = string
  description = "The Administrator Login for the PostgreSQL Flexible Server."
}

variable "PG_Admin_Password" {
  type        = string
  sensitive   = true
  description = "The Password associated with the administrator_login for the PostgreSQL Flexible Server."
}

####################################
### Managed PostgreSQL for Azure ###
####################################

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

  administrator_login    = var.PG_Admin_Username # See above variable definitions
  administrator_password = var.PG_Admin_Password

  sku_name       = "GP_Standard_D4ds_v4"
  pgsql_version  = "17"
  storagesize_mb = 262144

  ip_rules       = []
  firewall_rules = []

  diagnostics = {
    destination   = ""
    eventhub_name = ""
  }

  delegated_subnet_id = data.azurerm_subnet.postgresql.id
  private_dns_zone_id = data.azurerm_private_dns_zone.flex_dns_zone.id

  ## Keyvault
  environment                      = "dev"
  project                          = "myproject"
  kv_public_network_access_enabled = true
  kv_subnet_ids                    = local.subnet_ids
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
