# Terraform for Azure Managed Database PostgreSQL Flexible Server

Creates a PostgreSQL instance using the Azure Database for PostgreSQL - Flexible Server.

## Usage

Examples for this module along with various configurations can be found in the [examples/](examples/) folder.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.26 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | ~> 1.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.40.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_enc_key_vault"></a> [enc\_key\_vault](#module\_enc\_key\_vault) | git::https://gitlab.k8s.cloud.statcan.ca/cloudnative/platform/terraform/terraform-azure-key-vault.git | v5.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_access_policy.cmk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.runner_manage_keys](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.cmk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_monitor_diagnostic_setting.postgresql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_postgresql_flexible_server.pgsql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_active_directory_administrator.pgsql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_active_directory_administrator) | resource |
| [azurerm_postgresql_flexible_server_configuration.pgsql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_database.pgsql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [azurerm_postgresql_flexible_server_firewall_rule.pgsql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_firewall_rule) | resource |
| [azurerm_storage_account.pgsql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.pgsql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_user_assigned_identity.pgsql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.pointer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.pointer_sqladmin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_monitor_diagnostic_categories.postgresql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_directory_administrator"></a> [active\_directory\_administrator](#input\_active\_directory\_administrator) | n/a | <pre>list(object({<br/>    object_id      = optional(string)<br/>    principal_name = optional(string)<br/>    principal_type = optional(string, "Group")<br/>  }))</pre> | `[]` | no |
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | The Administrator Login for the PostgreSQL Flexible Server. | `string` | n/a | yes |
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | The Password associated with the administrator\_login for the PostgreSQL Flexible Server. | `string` | n/a | yes |
| <a name="input_databases"></a> [databases](#input\_databases) | The name, collation, and charset of the PostgreSQL database(s). (defaults: charset='utf8', collation='en\_US.utf8') | `map(map(string))` | n/a | yes |
| <a name="input_delegated_subnet_id"></a> [delegated\_subnet\_id](#input\_delegated\_subnet\_id) | The subnet where you want the database created. The subnet must be delegated to Microsoft.DBforPostgreSQL/flexibleServers. | `string` | `null` | no |
| <a name="input_diagnostics"></a> [diagnostics](#input\_diagnostics) | Diagnostic settings for those resources that support it. | <pre>object({<br/>    destination   = string<br/>    eventhub_name = string<br/>  })</pre> | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment used for keyvault access. | `string` | n/a | yes |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Specifies the Start IP Address associated with this Firewall Rule. | `list(string)` | n/a | yes |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server. | `bool` | `false` | no |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | List of public IP or IP ranges in CIDR Format. | `list(string)` | n/a | yes |
| <a name="input_kv_pointer_enable"></a> [kv\_pointer\_enable](#input\_kv\_pointer\_enable) | Flag kv\_pointer\_enable can either be `true` (state from key vault), or `false` (state from terraform). | `bool` | `false` | no |
| <a name="input_kv_pointer_name"></a> [kv\_pointer\_name](#input\_kv\_pointer\_name) | The key vault name to be used when kv\_pointer\_enable is set to `true`. | `string` | `null` | no |
| <a name="input_kv_pointer_rg"></a> [kv\_pointer\_rg](#input\_kv\_pointer\_rg) | The key vault resource group to be used when kv\_pointer\_enable is set to `true`. | `string` | `null` | no |
| <a name="input_kv_pointer_sqladmin_password"></a> [kv\_pointer\_sqladmin\_password](#input\_kv\_pointer\_sqladmin\_password) | The sqladmin password to be looked up in key vault when kv\_pointer\_enable is set to `true`. | `string` | `null` | no |
| <a name="input_kv_private_endpoints"></a> [kv\_private\_endpoints](#input\_kv\_private\_endpoints) | The information required to create a private endpoint for the Key Vault. | <pre>list(object({<br/>    sub_resource_name   = optional(string, "vault")<br/>    subnet_id           = string<br/>    private_dns_zone_id = string<br/>  }))</pre> | `[]` | no |
| <a name="input_kv_public_network_access_enabled"></a> [kv\_public\_network\_access\_enabled](#input\_kv\_public\_network\_access\_enabled) | (Required) Whether or not public network access is allowed. | `bool` | `false` | no |
| <a name="input_kv_subnet_ids"></a> [kv\_subnet\_ids](#input\_kv\_subnet\_ids) | The subnets for the key vault. | `list(string)` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. | `string` | `"canadacentral"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the PostgreSQL Flexible Server. | `string` | n/a | yes |
| <a name="input_pgsql_version"></a> [pgsql\_version](#input\_pgsql\_version) | The version of the PostgreSQL Flexible Server. Currently supported versions 13, 14, 15, 16, or 17. | `string` | `"17"` | no |
| <a name="input_postgresql_configurations"></a> [postgresql\_configurations](#input\_postgresql\_configurations) | n/a | `map(string)` | <pre>{<br/>  "azure.extensions": "POSTGIS,PGCRYPTO",<br/>  "checkpoint_warning": "0",<br/>  "client_min_messages": "log",<br/>  "connection_throttle.enable": "on",<br/>  "debug_pretty_print": "on",<br/>  "debug_print_parse": "off",<br/>  "debug_print_plan": "off",<br/>  "debug_print_rewritten": "off",<br/>  "log_checkpoints": "on",<br/>  "log_duration": "off",<br/>  "log_error_verbosity": "verbose",<br/>  "log_line_prefix": "%m [%p] %q[user=%u,db=%d,app=%a,client=%h] ",<br/>  "log_lock_waits": "off",<br/>  "log_min_duration_statement": "10",<br/>  "log_min_error_statement": "error",<br/>  "log_min_messages": "warning",<br/>  "log_statement": "ddl",<br/>  "maintenance_work_mem": "32000",<br/>  "max_wal_size": "512",<br/>  "min_wal_size": "512",<br/>  "pg_qs.query_capture_mode": "top",<br/>  "pg_qs.track_utility": "off",<br/>  "pg_stat_statements.track_utility": "off",<br/>  "pgaudit.log": "ddl",<br/>  "pgms_wait_sampling.query_capture_mode": "all",<br/>  "row_security": "on",<br/>  "temp_buffers": "16384",<br/>  "wal_buffers": "8192",<br/>  "wal_writer_delay": "200",<br/>  "wal_writer_flush_after": "128",<br/>  "work_mem": "2048000"<br/>}</pre> | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | The ID of the private DNS zone to create the PostgreSQL Flexible Server. The private DNS zone must end with the suffix .postgres.database.azure.com. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of client project | `string` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Specifies whether this PostgreSQL Flexible Server is publicly accessible. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the PostgreSQL Flexible Server. | `string` | n/a | yes |
| <a name="input_sa_create_log"></a> [sa\_create\_log](#input\_sa\_create\_log) | Creates a storage account to be used for diagnostics logging of the PostgreSQL database created if the variable is set to `true`. | `bool` | `false` | no |
| <a name="input_sa_subnet_ids"></a> [sa\_subnet\_ids](#input\_sa\_subnet\_ids) | The subnets for the storage account. | `list(string)` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Specifies the SKU Name for this PostgreSQL Flexible Server. | `string` | `"GP_Standard_D4ds_v4"` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of the storage account used for diagnostics (optional, if not provided the name is auto-generated). | `string` | `null` | no |
| <a name="input_storagesize_mb"></a> [storagesize\_mb](#input\_storagesize\_mb) | Specifies the storage size in MB for the PostgreSQL Flexible Server. | `number` | `262144` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_administrator_login"></a> [administrator\_login](#output\_administrator\_login) | n/a |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->

## History

[Change Log](./CHANGELOG.md)
