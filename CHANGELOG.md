# CHANGE LOG

## 1.1.0 (Nov 04, 2025)

FEATURES:

ENHANCEMENTS:

* Added ability to select PostgreSQL v17.

BUG FIXES:

## 1.0.0 (Aug 26, 2025)

FEATURES:

* Provider definitions and key vault dependancy updated to use AzureRM version 4.
* Updates to storage account container references from name to id, to support provider changes.
* Updates to support changes to diagnostics resource.
* Update default PostgreSQL version to 16.

ENHANCEMENTS:

* Added validations to variables pgsql_version and storagesize_mb.

BUG FIXES:

## 0.5.0 (Oct 25, 2024)

FEATURES:

ENHANCEMENTS:

BUG FIXES:

* `azurerm_postgresql_flexible_server` - updated public_network_access_enabled to default to false
* `azurerm_storage_account` - https_traffic_only_enabled renaming noted

## 0.4.1 (Sept 24, 2024)

FEATURES:

ENHANCEMENTS:

* `azurerm_key_vault_access_policy` - allow runner to list keys

BUG FIXES:

* `postgresql_extension` - removed due to erroneous behaviour

## 0.4.0 (March 13, 2024)

FEATURES:

ENHANCEMENTS:

* `enc_key_vault` - referring to latest keyvault module

BUG FIXES:
