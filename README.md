<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.89.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.98.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefixes"></a> [address\_prefixes](#input\_address\_prefixes) | The address prefixes to use for the subnet. | `list(string)` | n/a | yes |
| <a name="input_enforce_private_link_endpoint_network_policies"></a> [enforce\_private\_link\_endpoint\_network\_policies](#input\_enforce\_private\_link\_endpoint\_network\_policies) | Enable or Disable network policies for the private link endpoint on the subnet. Setting this to `true` will **Disable** the policy and setting this to `false` will **Enable** the policy. Default value is `false`. | `bool` | `false` | no |
| <a name="input_enforce_private_link_service_network_policies"></a> [enforce\_private\_link\_service\_network\_policies](#input\_enforce\_private\_link\_service\_network\_policies) | Enable or Disable network policies for the private link service on the subnet. Setting this to `true` will **Disable** the policy and setting this to `false` will **Enable** the policy. Default value is `false`. | `bool` | `false` | no |
| <a name="input_nat_gateway"></a> [nat\_gateway](#input\_nat\_gateway) | id: The ID of the NAT Gateway which should be associated with the Subnet. Changing this forces a new resource to be created. | <pre>object({<br>    id = string<br>  })</pre> | `null` | no |
| <a name="input_new_network_security_group_name"></a> [new\_network\_security\_group\_name](#input\_new\_network\_security\_group\_name) | Specifies the name of the new Network Security Group. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_new_network_security_group_tags"></a> [new\_network\_security\_group\_tags](#input\_new\_network\_security\_group\_tags) | A mapping of tags to assign to the Network Security Group. | `map(string)` | `null` | no |
| <a name="input_new_route_table_name"></a> [new\_route\_table\_name](#input\_new\_route\_table\_name) | The name of the new route table. Changing this forces a new route table to be created. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the subnet. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_route_table"></a> [route\_table](#input\_route\_table) | Leave this parameter null would create a new route table.<br>id: The ID of the Route Table which should be associated with the Subnet. Changing this forces a new route table association to be created.<br>name: The name of the route table. Changing this forces a new route table association to be created. | <pre>object({<br>    id   = string<br>    name = string<br>  })</pre> | `null` | no |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | Leave this parameter null would create a new Network Security Group.<br>id: The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new association to be created.<br>name: Specifies the name of the network security group. Changing this forces a new association to be created. | <pre>object({<br>    id   = string<br>    name = string<br>  })</pre> | `null` | no |
| <a name="input_service_endpoint_policy_ids"></a> [service\_endpoint\_policy\_ids](#input\_service\_endpoint\_policy\_ids) | The list of IDs of Service Endpoint Policies to associate with the subnet. | `list(string)` | `null` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | The list of Service endpoints to associate with the subnet. | `list(string)` | `null` | no |
| <a name="input_subnet_delegations"></a> [subnet\_delegations](#input\_subnet\_delegations) | Details: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#delegation<br>name: A name for this delegation.<br>service\_delegation:<br>  name: The name of service to delegate to. Possible values include<br>  actions: The name of service to delegate to. Possible values include | <pre>list(object({<br>    name = string<br>    service_delegation = object({<br>      name    = string<br>      actions = list(string)<br>    })<br>  }))</pre> | `null` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_virtual_network"></a> [virtual\_network](#input\_virtual\_network) | The virtual network which to attach the subnet. Changing this forces some new resources to be created.<br>id: The virtual NetworkConfiguration ID.<br>name: The name of the virtual network.<br>location: The location/region where the virtual network is created. | <pre>object({<br>    id       = string<br>    name     = string<br>    location = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | The id of the attached route table. |
| <a name="output_route_table_name"></a> [route\_table\_name](#output\_route\_table\_name) | The name of the attached route table. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The id of the attached network security group. |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | The name of the attached network security group. |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | The subnet ID. |
<!-- END_TF_DOCS -->