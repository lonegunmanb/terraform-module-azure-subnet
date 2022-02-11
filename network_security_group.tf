resource "azurerm_network_security_group" "this" {
  count               = local.create_new_security_group ? 1 : 0
  name                = coalesce(var.new_network_security_group_name, "${var.subnet_name}-nsg")
  resource_group_name = var.resource_group_name
  location            = local.location
  tags                = var.new_network_security_group_tags
}

locals {
  security_group_id   = local.create_new_security_group ? azurerm_network_security_group.this[0].id : var.security_group.id
  security_group_name = local.create_new_security_group ? azurerm_network_security_group.this[0].name : var.security_group.name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  network_security_group_id = local.security_group_id
  subnet_id                 = azurerm_subnet.this.id
}