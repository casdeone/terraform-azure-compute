variable "prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "vm_username" {
  type      = string
  sensitive = true
}

variable "vm_password" {
  type      = string
  sensitive = true
}

variable "vm_joindomain" {
  type = string
  description = "(optional) describe your variable"
}

variable "vm_joindomain_password" {
  type = string
  sensitive = true
}