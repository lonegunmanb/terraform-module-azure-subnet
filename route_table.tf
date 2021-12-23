resource "azurerm_route_table" "this" {
  count               = local.create_new_route_table ? 1 : 0
  location            = local.location
  name                = local.new_route_table_name
  resource_group_name = var.resource_group_name
}

locals {
  route_table_id = try(azurerm_route_table.this[0].id, var.route_table.id)
}

resource "azurerm_subnet_route_table_association" "this" {
  route_table_id = local.route_table_id
  subnet_id      = azurerm_subnet.this.id
}