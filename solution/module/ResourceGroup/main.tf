resource "azurerm_resource_group" "team5" {
    for_each = var.tupla_rg
    name = each.value.name
    location = each.value.location
}