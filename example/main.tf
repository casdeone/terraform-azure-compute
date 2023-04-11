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


module "test" {
  source = "../"
  vm_settings = [{
    name                = "server1"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    subnet_id           = azurerm_subnet.subnet.id
    enable_public_ip    = true
    vm_size             = "Standard_DS1_v2"
    admin_username      = "vmadmin"
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
      allowed_ip          = "38.44.194.233/32"
      prefix              = "dev"
      tags = {
        environment = "nonprod"
      }

  }]

}
