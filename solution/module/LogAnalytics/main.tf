resource "azurerm_resource_group" "team5" {
  name     = "team5-analytics"
  location = "East us 2"
}

resource "random_id" "workspace" {
  keepers = {
    # Generate a new id each time we switch to a new resource group
    group_name = azurerm_resource_group.team5.name
  }

  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "team5" {
  name                = "k8s-workspace-${random_id.workspace.hex}"
  location            = azurerm_resource_group.team5.location
  resource_group_name = azurerm_resource_group.team5.name
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "team5" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.team5.location
  resource_group_name   = azurerm_resource_group.team5.name
  workspace_resource_id = azurerm_log_analytics_workspace.team5.id
  workspace_name        = azurerm_log_analytics_workspace.team5.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}