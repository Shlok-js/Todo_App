resource "azurerm_mssql_server" "example" {
  name                         = "bhau-server-todosql"
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  version                      = "12.0"
  administrator_login          = "biscuitdada"
  administrator_login_password = "Biscuitbhava@1325"
}

