locals {
  associate_nat_gateway           = var.nat_gateway != null
  create_new_route_table          = var.route_table == null
  create_new_security_group       = var.security_group == null
  location                        = var.virtual_network.location
  new_route_table_name            = var.new_route_table_name == null ? "${var.subnet_name}-rt" : var.new_route_table_name
  new_network_security_group_name = var.new_network_security_group_name == null ? "${var.subnet_name}-nsg" : var.new_network_security_group_name
  virtual_network_name            = var.virtual_network.name
}