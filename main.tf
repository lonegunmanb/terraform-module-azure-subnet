#resource random_pet fail_test {
#
#}

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network.name
  address_prefixes     = var.address_prefixes
  dynamic "delegation" {
    for_each = var.subnet_delegation == null ? [] : toset([""])
    content {
      name = var.subnet_delegation.name
      service_delegation {
        name    = var.subnet_delegation.service_delegation.name
        actions = var.subnet_delegation.service_delegation.actions
      }
    }
  }
  #  enforce_private_link_endpoint_network_policies = var.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies = var.enforce_private_link_service_network_policies
  service_endpoints                             = var.service_endpoints
  service_endpoint_policy_ids                   = var.service_endpoint_policy_ids
}