output "security_group_id" {
  value = local.security_group_id
}

output "security_group_name" {
  value = local.security_group_name
}

output "subnet_id" {
  value = azurerm_subnet.this.id
}
