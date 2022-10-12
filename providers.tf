# Providers

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.5.0, < 3.0.0"
    }
  }

  required_version = ">= 0.14"
}
