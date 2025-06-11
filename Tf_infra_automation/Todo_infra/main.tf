    module "resource_group" {
      source                  = "../modules/azurerm_resource_group"
      resource_group_name     = "bhava_automation"
      resource_group_location = "Central India"
    }

    module "virtual_network" {
      depends_on = [module.resource_group]
      source     = "../modules/azurerm_virtual_network"

      virtual_network_name     = "vnet-todoapp"
      virtual_network_location = module.resource_group.location
      resource_group_name      = module.resource_group.name
      address_space            = ["10.0.0.0/16"]
    }

    module "frontend_subnet" {
      depends_on = [module.virtual_network]
      source     = "../modules/azurerm_subnet"

      resource_group_name  = module.resource_group.name
      virtual_network_name = "vnet-todoapp"
      subnet_name          = "frontend-subnet"
      address_prefixes     = ["10.0.1.0/24"]
    }

    module "backend_subnet" {
      depends_on = [module.virtual_network]
      source     = "../modules/azurerm_subnet"

      resource_group_name  = module.resource_group.name
      virtual_network_name = "vnet-todoapp"
      subnet_name          = "backend-subnet"
      address_prefixes     = ["10.0.2.0/24"]
    }

    # module "public_ip" {
    #   source              = "../modules/azurerm_public_ip"
    #   public_ip_name      = "pip-todoapp"
    #   resource_group_name = module.resource_group.name
    #   location            = module.resource_group.location
    #   allocation_method   = "Static"
    # }

    module "public_ip_frontend" {
      source              = "../modules/azurerm_public_ip"
      public_ip_name      = "pip-frontend"
      resource_group_name = module.resource_group.name
      location            = module.resource_group.location
      allocation_method   = "Static"
    }

    module "public_ip_backend" {
      source              = "../modules/azurerm_public_ip"
      public_ip_name      = "pip-backend"
      resource_group_name = module.resource_group.name
      location            = module.resource_group.location
      allocation_method   = "Static"
    }


    # HomeWork - Attach the above public IP to frontend VM

    module "frontend_vm" {
      depends_on = [module.frontend_subnet]
      source     = "../modules/azurerm_virtual_machine"

      resource_group_name = module.resource_group.name
      location            = module.resource_group.location
      vm_name             = "vm-frontend"
      vm_size             = "Standard_B2s"
      admin_username      = "devopsadmin"
      admin_password      = "Biscuitbhava@1325"
      image_publisher     = "Canonical"
      image_offer         = "0001-com-ubuntu-server-focal"
      image_sku           = "20_04-lts"
      image_version       = "latest"
      nic_name            = "nic-vm-frontend"
      # subnet_id           = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/bhava_automation/providers/Microsoft.Network/virtualNetworks/vnet-todoapp/subnets/frontend-subnet"
      subnet_id    = module.frontend_subnet.subnet_id
      public_ip_id = module.public_ip_frontend.public_ip_id
    }

    module "backend_vm" {
      depends_on = [module.backend_subnet]
      source     = "../modules/azurerm_virtual_machine"

      resource_group_name = module.resource_group.name
      location            = module.resource_group.location
      vm_name             = "vm-backend"
      vm_size             = "Standard_B1s"
      admin_username      = "devopsadmin"
      admin_password      = "Biscuitbhava@1325"
      image_publisher     = "Canonical"
      image_offer         = "0001-com-ubuntu-server-focal"
      image_sku           = "20_04-lts"
      image_version       = "latest"
      nic_name            = "nic-vm-backend"
      # subnet_id           = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/bhava_automation/providers/Microsoft.Network/virtualNetworks/vnet-todoapp/subnets/backend-subnet"
      subnet_id    = module.backend_subnet.subnet_id
      public_ip_id = module.public_ip_backend.public_ip_id
    }

    module "sql_server" {
      source                       = "../modules/azurerm_sql_server"
      sql_server_name              = "bhau-server-todosql"
      resource_group_name          = module.resource_group.name
      resource_group_location      = module.resource_group.location
      administrator_login          = "sqladmin"
      administrator_login_password = "Biscuitbhava@1325"
    }

    module "sql_database" {
      depends_on = [module.sql_server]
      source     = "../modules/azurerm_sql_database"

      sql_database_name = "tododb"
      sql_server_id     = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/bhava_automation/providers/Microsoft.Sql/servers/bhau-server-todosql"
    }


    output "frontend_public_ip" {
      value = module.public_ip_frontend.public_ip_address
    }

    output "backend_public_ip" {
      value = module.public_ip_backend.public_ip_address
    }