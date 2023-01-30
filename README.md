# terraform-azure-vm
terraform azure vm 

~~~

module "compute" {
  #source  = "app.terraform.io/denniscastillo/compute/azure"
  source = "github.com/casdeone/terraform-azure-compute.git?ref=v.1.1.0"
  #version = "1.0.0"
  location = "WestUS3"
  prefix = "casdeone"
  vm_prefix = "dev"
  environment = "nonprod"
  vm_size = "Standard_DS1_v2"
}

~~~