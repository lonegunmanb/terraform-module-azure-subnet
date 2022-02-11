variable "location" {
  type        = string
  nullable    = false
  description = "The Azure Region where the Resources should exist."
}

variable "vnet_cidrs" {
  type        = list(string)
  nullable    = false
  description = "The address space that is used the virtual network. You can supply more than one address space."
}