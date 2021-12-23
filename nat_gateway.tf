resource "azurerm_subnet_nat_gateway_association" "this" {
  count          = local.associate_nat_gateway ? 1 : 0
  nat_gateway_id = var.nat_gateway.id
  subnet_id      = azurerm_subnet.this.id
}