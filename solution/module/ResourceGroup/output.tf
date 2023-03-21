output "id" {
  value       = "${azurerm_resource_group.team5[*]}"
  description = "The resource group ID"
}
output "name" {
  value       = "${azurerm_resource_group.team5[*]}"
  description = "The name of the resource group."
}