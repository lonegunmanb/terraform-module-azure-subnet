output "security_group_id" {
  description = "The id of the attached network security group."
  value       = local.security_group_id
}

output "security_group_name" {
  description = "The name of the attached network security group."
  value       = local.security_group_name
}

output "subnet_id" {
  description = "The subnet ID."
  value       = azurerm_subnet.this.id
}

output "subnet_name" {
  description = "The subnet name"
  value       = azurerm_subnet.this.name
}

output "route_table_id" {
  description = "The id of the attached route table."
  value       = local.route_table_id
}

output "route_table_name" {
  description = "The name of the attached route table."
  value       = local.route_table_name
}