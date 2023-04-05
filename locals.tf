# Local Definitions

locals {
  diag_resource_list = (var.diagnostics != null) ? split("/", lower(var.diagnostics.destination)) : []

  parsed_diag = (var.diagnostics != null) ? {
    log_analytics_id   = contains(local.diag_resource_list, "microsoft.operationalinsights") ? var.diagnostics.destination : null
    storage_account_id = contains(local.diag_resource_list, "microsoft.storage") ? var.diagnostics.destination : var.sa_create_log ? azurerm_storage_account.pgsql[0].id : null
    event_hub_auth_id  = contains(local.diag_resource_list, "microsoft.eventhub") ? var.diagnostics.destination : null
    metric             = var.diagnostics.metrics
    log                = var.diagnostics.logs
    } : {
    log_analytics_id   = null
    storage_account_id = null
    event_hub_auth_id  = null
    metric             = []
    log                = []
  }
}
