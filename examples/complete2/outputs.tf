output "private_subnet_id" {
  value = module.private.subnet_id
}

output "private_subnet_security_group_id" {
  value = module.private.security_group_id
}

output "private_subnet_security_group_name" {
  value = module.private.security_group_name
}

output "private_subnet_route_table_id" {
  value = module.private.route_table_id
}

output "private_subnet_route_table_name" {
  value = module.private.route_table_name
}

output "public_subnet_id" {
  value = module.public.subnet_id
}

output "public_subnet_security_group_id" {
  value = module.public.security_group_id
}

output "public_subnet_security_group_name" {
  value = module.public.security_group_name
}

output "public_subnet_route_table_id" {
  value = module.public.route_table_id
}

output "public_subnet_route_table_name" {
  value = module.public.route_table_name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
