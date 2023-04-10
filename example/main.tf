


module "test" {
    source = "../"
    vm_settings = [{
      name           = "server1"
      location       = "westus3"
      vm_size        = "Standard_DS1_v2"
      admin_username = "admin"
      prefix         = "dev"
      tags = {
        environment = "nonprod"
      }
    }]
    
}