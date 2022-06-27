# Server

variable "administrator_login" {
  description = "(Required) The Administrator Login for the PostgreSQL Flexible Server."
}

variable "administrator_password" {
  description = "(Required) The Password associated with the administrator_login for the PostgreSQL Flexible Server."
}

variable "databases" {
  type        = map(map(string))
  description = "(Required) The name, collation, and charset of the PostgreSQL database(s). (defaults: charset='utf8', collation='en_US.utf8')"
}

variable "ip_rules" {
  type        = list(string)
  description = "(Required) List of public IP or IP ranges in CIDR Format."
}

variable "firewall_rules" {
  type        = list(string)
  description = "(Required) Specifies the Start IP Address associated with this Firewall Rule."
}

variable "geo_redundant_backup_enabled" {
  description = "(Optional) Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server."
  type        = bool
  default     = false
}

variable "location" {
  description = "(Optional) Specifies the supported Azure location where the resource exists."
  default     = "canadacentral"
}

variable "name" {
  description = "(Required) The name of the PostgreSQL Flexible Server."
}

variable "pgsql_version" {
  description = "(Required) The version of the PostgreSQL Flexible Server."
  default     = "13"
}

variable "resource_group" {
  description = "(Required) The name of the resource group in which to create the PostgreSQL Flexible Server."
}

variable "sku_name" {
  description = "(Required) Specifies the SKU Name for this PostgreSQL Flexible Server."
  default     = "GP_Standard_D4s_v3"
}

variable "storagesize_mb" {
  description = "(Required) Specifies the version of PostgreSQL to use."
  default     = 262144
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default = {
    environment : "dev"
  }
}

#########################################################
# Logging
#########################################################

variable "diagnostics" {
  description = "Diagnostic settings for those resources that support it."
  type = object({
    destination   = string
    eventhub_name = string
    logs          = list(string)
    metrics       = list(string)
  })
  default = null
}

variable "create_log_sa" {
  description = "(Optional) Creates a storage account to be used for diagnostics logging of the PostgreSQL database created if the variable is set to `true`."
  type        = bool
  default     = false
}

######################################################################
# kv_pointer_enable (pointers in key vault for secrets state)
# => ``true` then state from key vault is used for creation
# => ``false` then state from terraform is used for creation (default)
######################################################################

variable "kv_pointer_enable" {
  description = "(Optional) Flag kv_pointer_enable can either be `true` (state from key vault), or `false` (state from terraform)."
  default     = false
}

variable "kv_pointer_name" {
  description = "(Optional) The key vault name to be used when kv_pointer_enable is set to `true`."
  default     = null
}

variable "kv_pointer_rg" {
  description = "(Optional) The key vault resource group to be used when kv_pointer_enable is set to `true`."
  default     = null
}

variable "kv_pointer_sqladmin_password" {
  description = "(Optional) The sqladmin password to be looked up in key vault when kv_pointer_enable is set to `true`."
  default     = null
}

#########################################################
# Virtual Network Injection 
#########################################################

variable "subnet_id" {
  description = "The subnet where you want the database created. The subnet must be delegated to Microsoft.DBforPostgreSQL/flexibleServers."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to create the PostgreSQL Flexible Server. The private DNS zone must end with the suffix .postgres.database.azure.com."
  type        = string
  default     = null
}

#########################################################
# Parameters
#########################################################

variable "client_min_messages" {
  description = "(Optional) Sets the message levels that are sent to the client."
  default     = "log"
}

variable "debug_print_parse" {
  description = "(Optional) Logs each query's parse tree."
  default     = "off"
}

variable "debug_print_plan" {
  description = "(Optional) Logs each query's execution plan."
  default     = "off"
}

variable "debug_print_rewritten" {
  description = "(Optional) Logs each query's rewritten parse tree."
  default     = "off"
}

variable "log_checkpoints" {
  description = "(Optional) Logs each checkpoint."
  default     = "on"
}

variable "log_connections" {
  description = "(Optional) Logs each successful connection."
  default     = "on"
}

variable "log_disconnections" {
  description = "(Optional) Logs end of a session, including duration."
  default     = "on"
}

variable "log_duration" {
  description = "(Optional) Logs the duration of each completed SQL statement."
  default     = "off"
}

variable "log_error_verbosity" {
  description = "(Optional) Sets the verbosity of logged messages."
  default     = "default"
}

variable "log_lock_waits" {
  description = "(Optional) Logs long lock waits."
  default     = "off"
}

variable "log_min_duration_statement" {
  description = "(Optional) Sets the minimum execution time (in milliseconds) above which statements will be logged. -1 disables logging statement durations."
  default     = "10"
}

variable "log_min_error_statement" {
  description = "(Optional) Causes all statements generating error at or above this level to be logged."
  default     = "error"
}

variable "log_min_messages" {
  description = "(Optional) Sets the message levels that are logged."
  default     = "warning"
}

variable "log_statement" {
  description = "(Optional) Sets the type of statements logged."
  default     = "ddl"
}

variable "row_security" {
  description = "(Optional) Enable row security."
  default     = "on"
}

variable "checkpoint_warning" {
  description = "(Optional) Enables warnings if checkpoint segments are filled more frequently than this. Unit is s."
  default     = "0"
}

variable "connection_throttling" {
  description = "(Optional) Enables temporary connection throttling per IP for too many invalid password login failures."
  default     = "on"
}

variable "maintenance_work_mem" {
  description = "(Optional) Sets the maximum memory to be used for maintenance operations. Unit is kb."
  default     = "32000"
}

variable "min_wal_size" {
  description = "(Optional) Sets the minimum size to shrink the WAL to. Unt is mb."
  default     = "512"
}

variable "max_wal_size" {
  description = "(Optional) Sets the WAL size that triggers a checkpoint. Unit is mb."
  default     = "512"
}

variable "pg_stat_statements_track_utility" {
  description = "(Optional) Selects whether utility commands are tracked by pg_stat_statements."
  default     = "off"
}

variable "pg_qs_track_utility" {
  description = "(Optional) Selects whether utility commands are tracked by pg_qs."
  default     = "on"
}

variable "pg_qs_query_capture_mode" {
  description = "(Optional) Selects which statements are tracked by pg_qs."
  default     = "top"
}

variable "pgms_wait_sampling_query_capture_mode" {
  description = "(Optional) Selects which statements are tracked by the pgms_wait_sampling extension."
  default     = "all"
}

variable "synchronous_commit" {
  description = "(Optional) Sets the current transaction's synchronization level."
  default     = "on"
}

variable "temp_buffers" {
  description = "(Optional) Sets the maximum number of temporary buffers used by each database session. Unit is 8kb."
  default     = "16384"
}

variable "wal_buffers" {
  description = "(Optional) Sets the number of disk-page buffers in shared memory for WAL. Any change requires restarting the server to take effect. Unit is 8kb."
  default     = "8192"
}

variable "wal_writer_delay" {
  description = "(Optional) Time between WAL flushes performed in the WAL writer. Unit is ms."
  default     = "200"
}

variable "wal_writer_flush_after" {
  description = "(Optional) Amount of WAL written out by WAL writer that triggers a flush. Unit is 8kb."
  default     = "128"
}

variable "work_mem" {
  description = "(Optional) Sets the amount of memory to be used by internal sort operations and hash tables before writing to temporary disk files. Unit is kb."
  default     = "2048000"
}
