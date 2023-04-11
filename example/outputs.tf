output "vm_id" {
    value = [
        for vm in module.test.vm_id : vm
    ]
}

output "vm_ids" {
    value = [
        for vm in module.test.vm_ids : vm
    ]
}