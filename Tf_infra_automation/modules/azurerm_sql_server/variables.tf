variable  sql_server_name {
    description = "Name of the SQL Server"
    type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group where the SQL Server will be created"
  type        = string
}

variable "resource_group_location" {
  description = "Location where the SQL Server will be created"
  type        = string
}

variable "administrator_login" {
  description = "Administrator login for the SQL Server"
  type        = string
}

variable "administrator_login_password" {
  description = "Password for the SQL Server administrator login"
  type        = string
}

