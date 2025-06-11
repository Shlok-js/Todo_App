resource "azurerm_resource_group" "biscuit_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}