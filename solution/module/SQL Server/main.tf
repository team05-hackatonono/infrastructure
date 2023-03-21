resource "random_string" "str" {
  length  = 3
  special = false
  upper   = false
  number  = false
}

resource "random_password" "main" {
  length      = 24
  min_upper   = 4
  min_lower   = 2
  min_numeric = 4
  special     = false

  keepers = {
    administrator_login_password = var.sqlserver_name
  }
}

resource "azurerm_sql_server" "team5" {
  name                         = var.sqlserver_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = local.version
  administrator_login          = var.admin_username == null ? "sqladmin" : var.admin_username // It is a if Sentence.
  administrator_login_password = var.admin_password == null ? random_password.main.result : var.admin_password // It is a if Sentence.
  tags                         = var.tags
  identity                    {
    type                       = "SystemAssigned"
  }
}

resource "azurerm_sql_database" "db" {
  name                             = var.db_name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  server_name                      = azurerm_sql_server.team5.name //Dependencia implicita
  edition                          = var.sql_database_edition
  requested_service_objective_name = var.sqldb_service_objective_name 
  tags                             = merge({ "Name" = format("%s-primary", var.db_name) }, var.tags, )
  depends_on          = [azurerm_sql_server.team5]
}

resource "azurerm_sql_firewall_rule" "fw01" {
  count               = length(var.firewall_rules)
  name                = element(var.firewall_rules, count.index).name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.team5.name
  start_ip_address    = element(var.firewall_rules, count.index).start_ip_address
  end_ip_address      = element(var.firewall_rules, count.index).end_ip_address
  depends_on          = [azurerm_sql_server.team5]
}

resource "azurerm_monitor_diagnostic_setting" "extaudit" {
  name                       = lower("extaudit-${var.db_name}-diag")
  target_resource_id         = azurerm_sql_database.db.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  //storage_account_id         = azurerm_storage_account.sa.id
  depends_on                   = [azurerm_sql_database.db]

  dynamic "log" {
    for_each = var.extaudit_diag_logs
    content {
      category = log.value
      enabled  = true
      retention_policy {
        enabled = false
      }
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }

  lifecycle {
    ignore_changes = [log, metric]
  }
}