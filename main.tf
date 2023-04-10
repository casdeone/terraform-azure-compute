// create vm
resource "random_password" "password" {
  length  = 16
  special = true
  numeric = true
  upper   = true
  lower   = true
}


resource "azurerm_network_interface" "nic" {
  for_each = {for nic in var.vm_settings : "nic-${nic.name}" => nic}
  name                = "nic-${each.value.name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = each.value.tags

}

resource "azurerm_public_ip" "pip" {
  for_each = { for pip in var.vm_settings : "pip-${pip.name}" => pip}
  name                = "pip-${each.value.name}"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = "Dynamic"

  tags = each.value.tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each = {for vm in var.vm_settings : "vm-${vm.name}" => vm}
  name                          = "vm-${each.value.name}"
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
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

  tags = each.value.tags

  depends_on = [
    azurerm_network_interface.nic
  ]
 
}
