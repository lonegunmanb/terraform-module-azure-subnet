variable "location" {
  type        = string
  default     = "eastus"
  nullable    = false
  description = "The Azure Region where the Resources should exist."
}

variable "vnet_cidrs" {
  type     = list(string)
  nullable = false
}