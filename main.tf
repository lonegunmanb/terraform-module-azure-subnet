#resource random_pet fail_test {
#
#}

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_g roup_name  = var.resource_group_name
  virtual_network_name = var.virtual_network.name
  address_prefixes     = var.address_prefixes
  dynamic "delegation" {
    for_each = var.subnet_delegations == null ? [] : var.subnet_delegations
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
  enforce_private_link_endpoint_network_policies = var.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = var.enforce_private_link_service_network_policies
  service_endpoints                              = var.service_endpoints
  service_endpoint_policy_ids                    = var.service_endpoint_policy_ids
}