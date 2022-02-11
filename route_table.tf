resource "azurerm_route_table" "this" {
  count               = local.create_new_route_table ? 1 : 0
  location            = local.location
  name                = coalesce(var.new_route_table_name, "${var.subnet_name}-rt")
  resource_group_name = var.resource_group_name
}

locals {
  route_table_id   = local.create_new_route_table ? azurerm_route_table.this[0].id : var.route_table.id
  route_table_name = local.create_new_route_table ? azurerm_route_table.this[0].name : var.route_table.name
}

resource "azurerm_subnet_route_table_association" "this" {
  route_table_id = local.route_table_id
  subnet_id      = azurerm_subnet.this.id
}