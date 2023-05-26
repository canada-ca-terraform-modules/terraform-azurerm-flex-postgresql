# Providers

terraform {
  required_version = ">= 1.3.0, < 2.0.0"

  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 3.15, < 4.0"
      configuration_aliases = [azurerm.dns_zone_provider]
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.19.0"
    }
  }
}
