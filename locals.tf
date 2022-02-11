locals {
  create_new_route_table    = var.route_table == null
  create_new_security_group = var.security_group == null
  location                  = var.virtual_network.location
}