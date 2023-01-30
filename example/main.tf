module "vm" {
    source ="../"
    vm_size = "Standard_DS1_v2"
environment = "staging"
vm_prefix = "dts"
prefix = "shc"
}