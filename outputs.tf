output "vm_id" {
    value = {for vm in azurerm_windows_virtual_machine.vm : vm.id => vm.name}
}
