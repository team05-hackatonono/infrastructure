output "app_service_plan_id" {
  value       = azurerm_app_service_plan.team5.id
}

output "app_service_id" {
  value       = azurerm_app_service.team5.id
}

output "app_service_name" {
  value       = azurerm_app_service.team5.name
}

output "app_service_default_site_hostname" {
  value       = azurerm_app_service.team5.default_site_hostname
}

output "app_service_outbound_ip_addresses" {
  value       = split(",", azurerm_app_service.team5.outbound_ip_addresses)
}

output "app_service_possible_outbound_ip_addresses" {
  value       = split(",", azurerm_app_service.team5.possible_outbound_ip_addresses)
}

output "app_service_source_control" {
  value       = azurerm_app_service.team5.source_control
}

output "app_sp" {
  value = azurerm_app_service.team5.identity.*.principal_id
}

output "app_tenant_id" {
  value = azurerm_app_service.team5.identity.*.tenant_id
}

///ouput Application Insight
output "instrumentation_key" {
  value = azurerm_application_insights.team5.instrumentation_key
}

output "app_id" {
  value = azurerm_application_insights.team5.app_id
}