data "azuread_client_config" "current" {
}

resource "random_password" "password" {
  length = 20
  special = true
}
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.prefix}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.prefix}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]


}

resource "azurerm_key_vault" "kv" {
  location = azurerm_resource_group.rg.location
  name = "kv-casdeone"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name = "standard"
  tenant_id = data.azuread_client_config.current.tenant_id
  enable_rbac_authorization = true  
}

resource "azurerm_key_vault_secret" "username" {
  key_vault_id = azurerm_key_vault.kv.id
  name = "windows-admin-username"
  value = "vmadministrator"
  
}
resource "azurerm_key_vault_secret" "secret" {
  key_vault_id = azurerm_key_vault.kv.id
  name = "windows-admin-password"
  value = random_password.password.result
  
}


module "test" {
  source = "../"
  vm_settings = [{
    name                = "server1"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    subnet_id           = azurerm_subnet.subnet.id
    enable_public_ip    = true
    vm_size             = "Standard_DS1_v2"
    admin_username      = azurerm_key_vault_secret.username.value
    admin_password      = azurerm_key_vault_secret.secret.value
    allowed_ip          = "38.44.194.233/32"
    prefix              = "dev"
    tags = {
      environment = "nonprod"
    }
    },
    {
      name                = "server2"
      resource_group_name = azurerm_resource_group.rg.name
      location            = azurerm_resource_group.rg.location
      subnet_id           = azurerm_subnet.subnet.id
      enable_public_ip    = true
      vm_size             = "Standard_DS1_v2"
      admin_username      = "vmadmin"
      admin_password      = azurerm_key_vault_secret.secret.value
      allowed_ip          = "38.44.194.233/32"
      prefix              = "dev"
      tags = {
        environment = "nonprod"
      }

  }]

}


/* data "azurerm_key_vault_secret" "admin_username" {
  name         = "admin-username"
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = "admin-password"
  key_vault_id = var.key_vault_id
}

resource "azurerm_virtual_machine_extension" "join_adds" {
  name                 = "join-adds"
  virtual_machine_id   = azurerm_virtual_machine.example.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  
  settings = <<SETTINGS
    {
      "Name": "${var.domain_name}",
      "OUPath": "${var.ou_path}",
      "User": "${data.azurerm_key_vault_secret.admin_username.value}",
      "Restart": "true",
      "Options": "3",
      "DomainJoinOptions": "3",
      "JoinDomain": "${var.domain_name}",
      "Credentials": {
        "Password": "${data.azurerm_key_vault_secret.admin_password.value}",
        "Username": "${data.azurerm_key_vault_secret.admin_username.value}"
      }
    }
  SETTINGS
  
  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${data.azurerm_key_vault_secret.admin_password.value}"
    }
  PROTECTED_SETTINGS
} */