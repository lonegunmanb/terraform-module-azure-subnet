resource "azurerm_subnet_nat_gateway_association" "this" {
  count          = var.nat_gateway != null ? 1 : 0
  nat_gateway_id = var.nat_gateway.id
  subnet_id      = azurerm_subnet.this.id
}