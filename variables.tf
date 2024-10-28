###############
### Server ###
###############

variable "active_directory_administrator" {
  type = list(object({
    object_id      = optional(string)
    principal_name = optional(string)
    principal_type = optional(string, "Group")
  }))
  default = []

  validation {
    condition = alltrue([
      for entry in var.active_directory_administrator :
      (entry.object_id != null) &&
      (entry.principal_name != null) &&
      (entry.principal_type != null) &&
      (contains(["Group", "User", "ServicePrincipal"], entry.principal_type))
    ])
    error_message = "Invalid active_directory_administrator configuration. Make sure object_id, principal_name, and principal_type are not null, and principal_type is one of 'Group', 'User', or 'ServicePrincipal'."
  }
}

variable "administrator_login" {
  description = "The Administrator Login for the PostgreSQL Flexible Server."
}

variable "administrator_password" {
  description = "The Password associated with the administrator_login for the PostgreSQL Flexible Server."
  sensitive   = true
}

variable "databases" {
  type        = map(map(string))
  description = "The name, collation, and charset of the PostgreSQL database(s). (defaults: charset='utf8', collation='en_US.utf8')"
}

variable "ip_rules" {
  type        = list(string)
  description = "List of public IP or IP ranges in CIDR Format."
}

variable "firewall_rules" {
  type        = list(string)
  description = "Specifies the Start IP Address associated with this Firewall Rule."
}

variable "geo_redundant_backup_enabled" {
  description = "Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server."
  type        = bool
  default     = false
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists."
  default     = "canadacentral"
}

variable "name" {
  description = "The name of the PostgreSQL Flexible Server."
}

variable "storage_account_name" {
  description = "Name of the storage account used for diagnostics (optional, if not provided the name is auto-generated)."
  default     = null
}

variable "pgsql_version" {
  description = "The version of the PostgreSQL Flexible Server."
  default     = "13"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the PostgreSQL Flexible Server."
}

variable "sku_name" {
  description = "Specifies the SKU Name for this PostgreSQL Flexible Server."
  default     = "GP_Standard_D4ds_v4"
}

variable "storagesize_mb" {
  description = "Specifies the version of PostgreSQL to use."
  default     = 262144
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default = {
    environment : "dev"
  }
}

variable "project" {
  description = "Name of client project"
}

variable "environment" {
  description = "The environment used for keyvault access."
}


##################
### Networking ###
##################

variable "delegated_subnet_id" {
  description = "The subnet where you want the database created. The subnet must be delegated to Microsoft.DBforPostgreSQL/flexibleServers."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to create the PostgreSQL Flexible Server. The private DNS zone must end with the suffix .postgres.database.azure.com."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "(Optional) Specifies whether this PostgreSQL Flexible Server is publicly accessible."
  type        = bool
  default     = false
}

variable "kv_private_endpoints" {
  description = "The information required to create a private endpoint for the Key Vault."
  type = list(object({
    sub_resource_name   = optional(string, "vault")
    subnet_id           = string
    private_dns_zone_id = string
  }))
  default = []

  validation {
    condition = alltrue([
      for entry in var.kv_private_endpoints :
      contains(["vault"], entry.sub_resource_name)
    ])
    error_message = "Invalid sub_resource_name within var.kv_private_endpoints. Expected the name to be 'vault'."
  }

  validation {
    condition = alltrue([
      for entry in var.kv_private_endpoints :
      element(split("/", entry.private_dns_zone_id), 8) == "privatelink.vaultcore.azure.net"
    ])
    error_message = "Invalid private_dns_zone_id attribute within var.kv_private_endpoints. Expected a Private DNS Zone with the name 'privatelink.vaultcore.azure.net'"
  }
}

variable "kv_public_network_access_enabled" {
  description = "(Required) Whether or not public network access is allowed."
  default     = false
}

variable "kv_subnet_ids" {
  description = "The subnets for the key vault."
  type        = list(string)
  default     = null
}

variable "sa_subnet_ids" {
  description = "The subnets for the storage account."
  type        = list(string)
  default     = null
}

###############
### Logging ###
###############

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

variable "sa_create_log" {
  description = "Creates a storage account to be used for diagnostics logging of the PostgreSQL database created if the variable is set to `true`."
  type        = bool
  default     = false
}

##################
### KV Pointer ###
##################

######################################################################
# kv_pointer_enable (pointers in key vault for secrets state)
# => ``true` then state from key vault is used for creation
# => ``false` then state from terraform is used for creation (default)
######################################################################

variable "kv_pointer_enable" {
  description = "Flag kv_pointer_enable can either be `true` (state from key vault), or `false` (state from terraform)."
  default     = false
}

variable "kv_pointer_name" {
  description = "The key vault name to be used when kv_pointer_enable is set to `true`."
  default     = null
}

variable "kv_pointer_rg" {
  description = "The key vault resource group to be used when kv_pointer_enable is set to `true`."
  default     = null
}

variable "kv_pointer_sqladmin_password" {
  description = "The sqladmin password to be looked up in key vault when kv_pointer_enable is set to `true`."
  default     = null
}

##################
### Parameters ###
##################

variable "postgresql_configurations" {
  type = map(string)
  default = {
    "azure.extensions"                      = "POSTGIS,PGCRYPTO"
    "client_min_messages"                   = "log"
    "debug_pretty_print"                    = "on"
    "debug_print_parse"                     = "off"
    "debug_print_plan"                      = "off"
    "debug_print_rewritten"                 = "off"
    "log_checkpoints"                       = "on"
    "log_duration"                          = "off"
    "log_error_verbosity"                   = "verbose"
    "log_line_prefix"                       = "%m [%p] %q[user=%u,db=%d,app=%a,client=%h] "
    "log_lock_waits"                        = "off"
    "log_min_duration_statement"            = "10"
    "log_min_error_statement"               = "error"
    "log_min_messages"                      = "warning"
    "log_statement"                         = "ddl"
    "row_security"                          = "on"
    "checkpoint_warning"                    = "0"
    "connection_throttle.enable"            = "on"
    "maintenance_work_mem"                  = "32000"
    "min_wal_size"                          = "512"
    "max_wal_size"                          = "512"
    "pg_stat_statements.track_utility"      = "off"
    "pg_qs.track_utility"                   = "off"
    "pg_qs.query_capture_mode"              = "top"
    "pgaudit.log"                           = "ddl"
    "pgms_wait_sampling.query_capture_mode" = "all"
    "temp_buffers"                          = "16384"
    "wal_buffers"                           = "8192"
    "wal_writer_delay"                      = "200"
    "wal_writer_flush_after"                = "128"
    "work_mem"                              = "2048000"
  }
}
