provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "eastus"
  name     = "zjhe-vnet-test"
}

#resource "azurerm_virtual_network" "vnet" {
#  address_space       = ["10.0.0.0/16"]
#  location            = azurerm_resource_group.rg.location
#  name                = "zjhe-vnet-test"
#  resource_group_name = azurerm_resource_group.rg.name
#}

#module "subnet" {
#  source                                         = "../../"
#  address_prefixes                               = ["10.0.0.0/24"]
#  resource_group_name                            = azurerm_resource_group.rg.name
#  subnet_name                                    = "zjhe-subnet"
#  virtual_network_name                           = azurerm_virtual_network.vnet.name
#  generated_network_security_rule_start_priority = 500
#  generated_network_security_rule_priority_step  = 100
#  private                                        = true
#}