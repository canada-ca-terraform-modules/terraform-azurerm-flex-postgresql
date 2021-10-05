# Terraform for Azure Managed Database PostgreSQL Flexible Server

Creates a PostgreSQL instance using the Azure Managed Database for PostgreSQL Flexible Server.

## Security Controls

- TBD

## Dependencies

- Terraform v0.14.x +
- Terraform AzureRM Provider 2.5 +

## Enabling Extensions

Azure Database for PostgreSQL supports a subset of key extensions that are listed in the link below. This information is also available by running `SELECT * FROM pg_available_extensions;`.

For instance, application teams that have functionality that needs encryption can enable pg_crypto by using the `CREATE EXTENSION` command.

https://docs.microsoft.com/en-us/azure/postgresql/concepts-extensions

## Usage

Examples for this module along with various configurations can be found in the [examples/](examples/) folder.

## Variables

| Name                         | Type             | Default             | Required | Description                                                                                                                     |
| ---------------------------- | ---------------- | ------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------- |
| administrator_login          | string           | n/a                 | yes      | The Administrator Login for the PostgreSQL Flexible Server.                                                                     |
| administrator_login_password | string           | n/a                 | yes      | The Administrator Password associated with the administrator_login for the PostgreSQL Flexible Server.                          |
| databases                    | map(map(string)) | n/a                 | yes      | The name, collatation, and charset of the PostgreSQL database(s). (defaults: charset="utf8", collation="en_US.utf8")            |
| ip_rules                     | list             | n/a                 | yes      | List of public IP or IP ranges in CIDR Format.                                                                                  |
| firewall_rules               | list             | n/a                 | yes      | Specifies the Firewall Rules.                                                                                                   |
| key_size                     | number           | `2048`              | no       | Size of key to create in the Key Vault.                                                                                         |
| key_type                     | string           | `"RSA"`             | no       | Type of key to create in the Key Vault.                                                                                         |
| kv_workflow_enable           | string           | `"false"`           | no       | If kv_workflow_enable is set to `true` then enable storing pointers to secrets in key vault else `false` then store as default. |
| kv_workflow_name             | string           | `""`                | no       | The name used for the Key Vault Workflow.                                                                                       |
| kv_workflow_rg               | string           | `""`                | no       | The resource group used for the Key Vault Workflow.                                                                             |
| kv_workflow_salogging_rg     | string           | n/a                 | yes      | The storage account resource group used for the Key Vault Workflow.                                                             |
| location                     | string           | `"canadacentral"`   | no       | Specifies the supported Azure location where the resource exists.                                                               |
| name                         | string           | n/a                 | yes      | The name of the PostgreSQL Flexible Server.                                                                                     |
| pgsql_version                | string           | `"9.6"`             | no       | The version of the PostgreSQL Flexible Server.                                                                                  |
| resource_group               | string           | n/a                 | yes      | The name of the resource group in which to create the PostgreSQL Flexible Server.                                               |
| sku_name                     | string           | `"GP_Gen5_4"`       | no       | Specifies the SKU Name for this PostgreSQL Flexible Server.                                                                     |
| storagesize_mb               | string           | `"640000"`          | no       | Specifies the storage size the PostgreSQL Flexible Server uses.                                                                 |
| tags                         | map              | `"<map>"`           | n/a      | A mapping of tags to assign to the resource.                                                                                    |
| vnet_cidr                    | string           | `172.15.0.0/16`     | n/a      | Virtual Network CIDR.                                                                                                           |
| vnet_create                  | string           | `"false"`           | n/a      | If vnet_create is set to `true` then enable creation of new vnet else `false` then point to an existing one.                    |
| vnet_name                    | string           | n/a                 | yes      | Name for your Virtual Network.                                                                                                  |
| vnet_rg                      | string           | `""`                | n/a      | The Virtual Network resource group.                                                                                             |
| subnet_address_prefixes      | list             | `["172.15.8.0/22"]` | n/a      | Virtual Network Address Prefixes.                                                                                               |
| subnet_create                | string           | `"false"`           | n/a      | If subnet_create is set to `true` then enable creation of new subnet else `false` then point to an existing one.                |
| subnet_name                  | string           | n/a`                | yes      | Name for your Subnet.                                                                                                           |

## Variables (PostgreSQL Configuration)

| Name                                  | Type   | Default     | Required | Description                                                                                                                          |
| ------------------------------------- | ------ | ----------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| client_min_messages                   | string | `"log"`     | no       | Sets the message levels that are sent to the client.                                                                                 |
| debug_print_parse                     | string | `"off"`     | no       | Logs each query's parse tree.                                                                                                        |
| debug_print_plan                      | string | `"off"`     | no       | Logs each query's execution plan.                                                                                                    |
| debug_print_rewritten                 | string | `"off"`     | no       | Logs each query's rewritten parse tree.                                                                                              |
| log_checkpoints                       | string | `"off"`     | no       | Logs each checkpoint.                                                                                                                |
| log_connections                       | string | `"on"`      | no       | Logs each successful connection.                                                                                                     |
| log_disconnections                    | string | `"on"`      | no       | Logs end of a session, including duration.                                                                                           |
| log_duration                          | string | `"off"`     | no       | Logs the duration of each completed SQL statement.                                                                                   |
| log_error_verbosity                   | string | `"default"` | no       | Sets the verbosity of logged messages.                                                                                               |
| log_lock_waits                        | string | `"off"`     | no       | Logs long lock waits.                                                                                                                |
| log_min_duration_statement            | string | `"10"`      | no       | Sets the minimum execution time (in milliseconds) above which statements will be logged.                                             |
| log_min_error_statement               | string | `"error"`   | no       | Causes all statements generating error at or above this level to be logged.                                                          |
| log_min_messages                      | string | `"warning"` | no       | Sets the message levels that are logged.                                                                                             |
| log_statement                         | string | `"ddl"`     | no       | Sets the type of statements logged.                                                                                                  |
| row_security                          | string | `"on"`      | no       | Enable row security.                                                                                                                 |
| checkpoint_warning                    | string | `"0"`       | no       | Enables warnings if checkpoint segments are filled more frequently than this.                                                        |
| connection_throttle.enable            | string | `"on"`      | no       | Enables temporary connection throttling per IP for too many invalid password login failures.                                         |
| maintenance_work_mem                  | string | `"32000"`   | no       | Sets the maximum memory to be used for maintenance operations. Unit is kb.                                                           |
| min_wal_size                          | string | `"512"`     | no       | Sets the minimum size to shrink the WAL to. Unit is mb.                                                                              |
| max_wal_size                          | string | `"512"`     | no       | Sets the WAL size that triggers a checkpoint. Unit is mb.                                                                            |
| pg_stat_statements_track_utility      | string | `"off"`     | no       | Selects whether utility commands are tracked by pg_stat_statements.                                                                  |
| pg_qs_track_utility                   | string | `"on"`      | no       | Selects whether utility commands are tracked by pg_qs.                                                                               |
| pg_qs_query_capture_mode              | string | `"top"`     | no       | Selects which statements are tracked by pg_qs.                                                                                       |
| pgms_wait_sampling_query_capture_mode | string | `"all"`     | no       | Selects which statements are tracked by the pgms_wait_sampling extension.                                                            |
| synchronous_commit                    | string | `"on"`      | no       | Sets the current transaction's synchronization level.                                                                                |
| temp_buffers                          | string | `"16384"`   | no       | Sets the maximum number of temporary buffers used by each database session. Unit is 8kb.                                             |
| wal_buffers                           | string | `"8192"`    | no       | Sets the number of disk-page buffers in shared memory for WAL. Unit is 8kb.                                                          |
| wal_writer_delay                      | string | `"200"`     | no       | Time between WAL flushes performed in the WAL writer. Unit is ms.                                                                    |
| wal_writer_flush_after                | string | `"128"`     | no       | Amount of WAL written out by WAL writer that triggers a flush. Unit is 8kb.                                                          |
| work_mem                              | string | `"2048000"` | no       | Sets the amount of memory to be used by internal sort operations and hash tables before writing to temporary disk files. Unit is kb. |

## History

| Date     | Release | Change                                      |
| -------- | ------- | ------------------------------------------- |
| 20211004 | v1.0.0  | The initial release of the Terraform module |
