variable "location" {
  type        = string
  nullable    = false
  description = "The Azure Region where the Resources should exist."
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "The resource group name that is used by example. Leave this variable null will generate a random resource group name."
}

variable "vnet_cidrs" {
  type        = list(string)
  nullable    = false
  description = "The address space that is used the virtual network. You can supply more than one address space."
}