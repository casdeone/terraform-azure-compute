#create variables
variable "tags" {
  type = map(string)
  default = {
    "business_criticality"       = "high",
    "application"                = "splunk",
    "value_stream"               = "logging",
    "responsible_group_manager"  = "steven.simpauco@sharp.com",
    "responsible_group_org_name" = "dts",
    "deployed_by"                = "dennis.castillo@sharp.com"
  }
}

variable "vm_tags" {
  type = map(string)
  default = {
    //"backup"                    = "yes",
    //"dns_name"                   = "vm.casdeone.com",
    "shcappusage"                = "imaging",
    "shcsecuirtycompliance"      = "yes",
    "responsible_group_org_name" = "dts",
    "data_classification"        = "private"
  }
}

variable "required_tags" {
  type        = string
  description = "required tags"
  default     = "business_criticality,application,deployed_by,value_stream,responsible_group_manager,responsible_group_org_name"
}

variable "vm_required_tags" {
  type        = string
  description = "required tags"
  default     = "backup,dns_name,shcappusage,shcsecuirtycompliance,data_classification"
}

/*
variable "tfe_team_token" {
  type        = string
  description = "tfe team token"
}
*/


variable "location" {
  type        = string
  description = "location"
  default     = "West US 3"
}

variable "prefix" {
  type    = string
  default = "dts"

}
variable "vm_prefix" {
  type        = string
  default     = "tfvm"
  description = "vm prefix"
}

variable "environment" {
  type        = string
  default     = "staging"
  description = "environment"
}

variable "vm_size" {
  type        = string
  description = "virtual machine size"
}