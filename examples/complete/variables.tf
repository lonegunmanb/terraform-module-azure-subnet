variable "location" {
  type        = string
  default     = "eastus"
  nullable    = false
  description = "The Azure Region where the Resources should exist."
}

variable "namespace" {
  type        = string
  default     = "ms-tf-module-lab"
  nullable    = false
  description = "The namespace of resources, only used in naming."
}