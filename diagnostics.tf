###################
### Diagnostics ###
###################

# Manages a Diagnostic Setting for an existing Resource.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
#
resource "azurerm_monitor_diagnostic_setting" "postgresql_server" {
  count = (var.diagnostics != null) ? 1 : 0

  name                           = "${var.name}-pgsql-diag"
  target_resource_id             = azurerm_postgresql_flexible_server.pgsql.id
  log_analytics_workspace_id     = local.parsed_diag.log_analytics_id
  eventhub_authorization_rule_id = local.parsed_diag.event_hub_auth_id
  eventhub_name                  = local.parsed_diag.event_hub_auth_id != null ? var.diagnostics.eventhub_name : null
  storage_account_id             = local.parsed_diag.storage_account_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.postgresql_server[0].logs

    content {
      category = log.value
      enabled  = contains(local.parsed_diag.log, "all") || contains(local.parsed_diag.log, log.value)
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.postgresql_server[0].metrics

    content {
      category = metric.value
      enabled  = contains(local.parsed_diag.metric, "all") || contains(local.parsed_diag.metric, metric.value)
    }
  }
}
