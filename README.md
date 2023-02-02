# Terraform for Azure Managed Database PostgreSQL Flexible Server

Creates a PostgreSQL instance using the Azure Database for PostgreSQL - Flexible Server.

## Usage

Examples for this module along with various configurations can be found in the [examples/](examples/) folder.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.15, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.15, < 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_enc_key_vault"></a> [enc\_key\_vault](#module\_enc\_key\_vault) | git::https://gitlab.k8s.cloud.statcan.ca/cloudnative/platform/terraform/terraform-azure-key-vault.git | v1.1.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | The Administrator Login for the PostgreSQL Flexible Server. | `any` | n/a | yes |
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | The Password associated with the administrator\_login for the PostgreSQL Flexible Server. | `any` | n/a | yes |
| <a name="input_databases"></a> [databases](#input\_databases) | The name, collation, and charset of the PostgreSQL database(s). (defaults: charset='utf8', collation='utf8\_unicode\_ci') | `map(map(string))` | n/a | yes |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Specifies the Start IP Address associated with this Firewall Rule. | `list(string)` | n/a | yes |
| <a name="input_iops"></a> [iops](#input\_iops) | The storage IOPS for the PostgreSQL Flexible Server. | `any` | n/a | yes |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | List of public IP or IP ranges in CIDR Format. | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the PostgreSQL Flexible Server. | `any` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The name of the resource group in which to create the PostgreSQL Flexible Server. | `any` | n/a | yes |
| <a name="input_create_log_sa"></a> [create\_log\_sa](#input\_create\_log\_sa) | Creates a storage account to be used for diagnostics logging of the PostgreSQL database created if the variable is set to `true`. | `bool` | `false` | no |
| <a name="input_diagnostics"></a> [diagnostics](#input\_diagnostics) | Diagnostic settings for those resources that support it. | <pre>object({<br>    destination   = string<br>    eventhub_name = string<br>    logs          = list(string)<br>    metrics       = list(string)<br>  })</pre> | `null` | no |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server. | `bool` | `false` | no |
| <a name="input_innodb_buffer_pool_size"></a> [innodb\_buffer\_pool\_size](#input\_innodb\_buffer\_pool\_size) | The size in bytes of the buffer pool, the memory area where InnoDB caches table and index data. | `number` | `12884901888` | no |
| <a name="input_kv_pointer_enable"></a> [kv\_pointer\_enable](#input\_kv\_pointer\_enable) | Flag kv\_pointer\_enable can either be `true` (state from key vault), or `false` (state from terraform). | `bool` | `false` | no |
| <a name="input_kv_pointer_name"></a> [kv\_pointer\_name](#input\_kv\_pointer\_name) | The key vault name to be used when kv\_pointer\_enable is set to `true`. | `any` | `null` | no |
| <a name="input_kv_pointer_rg"></a> [kv\_pointer\_rg](#input\_kv\_pointer\_rg) | The key vault resource group to be used when kv\_pointer\_enable is set to `true`. | `any` | `null` | no |
| <a name="input_kv_pointer_sqladmin_password"></a> [kv\_pointer\_sqladmin\_password](#input\_kv\_pointer\_sqladmin\_password) | The sqladmin password to be looked up in key vault when kv\_pointer\_enable is set to `true`. | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. | `string` | `"canadacentral"` | no |
| <a name="input_max_allowed_packet"></a> [max\_allowed\_packet](#input\_max\_allowed\_packet) | The maximum size of one packet or any generated/intermediate string. | `number` | `536870912` | no |
| <a name="input_pgsql_version"></a> [pgsql\_version](#input\_pgsql\_version) | The version of the PostgreSQL Flexible Server. | `string` | `"13"` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | The ID of the private DNS zone to create the PostgreSQL Flexible Server. The private DNS zone must end with the suffix .postgres.database.azure.com. | `string` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Specifies the SKU Name for this PostgreSQL Flexible Server. | `string` | `"GP_Standard_D4ds_v4"` | no |
| <a name="input_storagesize_gb"></a> [storagesize\_gb](#input\_storagesize\_gb) | Specifies the version of PostgreSQL to use. | `number` | `128` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnet where you want the database created. The subnet must be delegated to Microsoft.DBforPostgreSQL/flexibleServers. | `string` | `null` | no |
| <a name="input_table_definition_cache"></a> [table\_definition\_cache](#input\_table\_definition\_cache) | The size of the table\_definition\_cache. | `number` | `5000` | no |
| <a name="input_table_open_cache"></a> [table\_open\_cache](#input\_table\_open\_cache) | The size of the table\_open\_cache. | `number` | `5000` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | <pre>{<br>  "environment": "dev"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_administrator_login"></a> [administrator\_login](#output\_administrator\_login) | n/a |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->

## History

| Date       | Release | Change                                               |
| ---------- | ------- | ---------------------------------------------------- |
| 2022-06-01 | v0.1.0  | Initial commit                                       |
| 2023-02-01 | v0.2.0  | Standards alignment and Customer Managed Key Support |
