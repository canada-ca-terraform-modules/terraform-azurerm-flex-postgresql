# Providers

terraform {
  required_version = "~> 1.5.7"

  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~> 4.26"
      configuration_aliases = [azurerm.dns_zone_provider]
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.25.0"
    }
  }
}
