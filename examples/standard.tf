provider "azurerm" {
  features {}
  alias = "dns_zone_provider"
}

# IDs for the subnets and private dns zones used by PostgreSQL and its Key Vault
locals {
  pg_subnet_id           = ""
  pg_private_dns_zone_id = ""
  kv_subnet_id           = ""
  kv_private_dns_zone_id = ""
}

# These variables have their values set as CI/CD Variables with the names TF_VAR_PG_Admin_Username and TF_VAR_PG_Admin_Password
variable "PG_Admin_Username" {
  type        = string
  description = "The Administrator Login for the PostgreSQL Flexible Server."
}

variable "PG_Admin_Password" {
  type        = string
  sensitive   = true
  description = "The Password associated with the administrator_login for the PostgreSQL Flexible Server."
}

# PostgreSQL Flexible Server
# It is recommended to set your module name to the same as the "name" parameter
module "postgresql-example" {
  source = "../"

  name                = "postgresql-example"
  project             = "example"
  environment         = "dev"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  databases = {
    dbexample01 = { chartset = "utf8", collation = "en_CA.utf8" },
    dbexample02 = { chartset = "utf8", collation = "en_US.utf8" },
  }

  administrator_login    = var.PG_Admin_Username # See above variable definitions
  administrator_password = var.PG_Admin_Password

  sku_name       = "GP_Standard_D4ds_v4"
  pgsql_version  = "18"
  storagesize_mb = 32768

  ip_rules       = []
  firewall_rules = []

  diagnostics = {
    destination   = ""
    eventhub_name = ""
  }

  delegated_subnet_id = local.pg_subnet_id
  private_dns_zone_id = local.pg_private_dns_zone_id

  ## Keyvault
  kv_subnet_ids = [local.pg_subnet_id]
  kv_private_endpoints = [
    {
      subnet_id           = local.kv_subnet_id
      private_dns_zone_id = local.kv_private_dns_zone_id
    }
  ]
  ## Storage Account
  sa_create_log = true
  sa_subnet_ids = [local.pg_subnet_id]

  tags = {
    "tier" = "k8s"
  }

  providers = {
    azurerm.dns_zone_provider = azurerm.dns_zone_provider
  }
}
