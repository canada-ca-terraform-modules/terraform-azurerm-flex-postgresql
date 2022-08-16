provider "azurerm" {
  features {}
}

module "postgresql_example" {
  source = "git::https://github.com/canada-ca-terraform-modules/terraform-azurerm-flex-postgresql.git?ref=v0.0.1"

  name = "psqlservername"
  databases = {
    psqlservername1 = { collation = "en_US.utf8" },
    psqlservername2 = { chartset = "utf8" },
    psqlservername3 = { chartset = "utf8", collation = "en_US.utf8" },
    psqlservername4 = {}
  }

  administrator_login    = "psqladmin"
  administrator_password = "pgsql1313"

  sku_name       = "GP_Standard_D4ds_v4"
  pgsql_version  = "13"
  storagesize_mb = 262144

  location       = "canadacentral"
  resource_group = "psql-dev-rg"

  ip_rules       = []
  firewall_rules = []

  diagnostics = {
    destination   = ""
    eventhub_name = ""
    logs          = ["all"]
    metrics       = ["all"]
  }

  tags = {
    "tier" = "k8s"
  }

}
