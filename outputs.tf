output "vm_id" {
    value = [for vm in azurerm_windows_virtual_machine.vm : tomap({
        name = vm.name
        id = vm.id
    })]
}

output "vm_ids" {
    value = [for vm in azurerm_windows_virtual_machine.vm : tomap({
        name = vm.name
        id = vm.id
    })]
}
