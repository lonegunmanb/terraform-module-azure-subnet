terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/azurerm"
      version = ">= 2.89.0"
    }
  }
}
