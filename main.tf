// create vm
resource "random_password" "password" {
  length  = 16
  special = true
  numeric = true
  upper   = true
  lower   = true
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


resource "azurerm_network_interface" "nic" {
  for_each = {for nic in var.vm_settings : "nic-${nic.name}" => nic}
  name                = "nic-${each.value.name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip["pip-${each.value.name}"].id
  }
  tags = each.value.tags

  depends_on = [
    azurerm_public_ip.pip
  ]

}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  for_each = {for nsg in var.vm_settings : "nsg-${nsg.name}" => nsg}
  name                = "nsg-${each.value.name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = each.value.allowed_ip
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg" {
  for_each = {for nsg in var.vm_settings : "nsg-${nsg.name}" => nsg}
  network_interface_id      = azurerm_network_interface.nic["nic-${each.value.name}"].id
  network_security_group_id = azurerm_network_security_group.nsg["nsg-${each.value.name}"].id
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
