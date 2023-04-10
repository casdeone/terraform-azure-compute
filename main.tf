// create vm
resource "random_password" "password" {
  length  = 16
  special = true
  numeric = true
  upper   = true
  lower   = true
}
resource "azurerm_resource_group" "rg" {
  for_each = {for rg in var.vm_settings : "rg-${rg.name}" => rg}
  name     = "${each.value.prefix}-rg"
  location = each.value.location
  tags = merge(each.value.tags, {
    environment = "staging"
  })
}

resource "azurerm_virtual_network" "vnet" {
  for_each = {for vnet in var.vm_settings : "vnet-${vnet.name}" => vnet}
  name                = "vnet-${each.value.prefix}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg["rg-${each.value.name}"].location
  resource_group_name = azurerm_resource_group.rg["rg-${each.value.name}"].name
  tags = merge(each.value.tags,)

}

resource "azurerm_subnet" "subnet" {
  for_each = {for subnet in var.vm_settings : "subnet-${subnet.name}" => subnet}
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg["rg-${each.value.name}"].name
  virtual_network_name = azurerm_virtual_network.vnet["vnet-${each.value.name}"].name
  address_prefixes     = ["10.0.2.0/24"]


}

resource "azurerm_network_interface" "nic" {
  for_each = {for nic in var.vm_settings : "nic-${nic.name}" => nic}
  name                = "nic-${each.value.prefix}"
  location            = azurerm_resource_group.rg["rg-${each.value.name}"].location
  resource_group_name = azurerm_resource_group.rg["rg-${each.value.name}"].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet["subnet-${each.value.name}"].id
    private_ip_address_allocation = "Dynamic"
  }
  tags = merge(each.value.tags)

}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each = {for vm in var.vm_settings : "vm-${vm.name}" => vm}
  name                          = "vm-${each.value.name}"
  location                      = azurerm_resource_group.rg["rg-${each.value.name}"].location
  resource_group_name           = azurerm_resource_group.rg["rg-${each.value.name}"].name
  size                          = each.value.vm_size
  admin_username                = each.value.admin_username
  admin_password                = random_password.password.result

  network_interface_ids = [azurerm_network_interface.nic["nic-${each.value.name}"].id]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
}
