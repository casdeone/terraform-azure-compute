#create variables

variable "vm_settings" {
  type = list(object({
    name           = string
    resource_group_name = string
    location       = string
    subnet_id = string
    vm_size        = string
    enable_public_ip = bool
    allowed_ip = string
    admin_username = optional(string, "vmadmin")
    admin_password = optional(string)
    prefix         = string
    tags           = map(string)

  }))
}
