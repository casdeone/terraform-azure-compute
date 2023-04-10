#create variables

variable "vm_settings" {
  type = list(object({
    name           = string
    location       = string
    vm_size        = string
    admin_username = optional(string, "vmadmin")
    admin_password = optional(string)
    prefix         = string
    tags           = map(string)

  }))
}
