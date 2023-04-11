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