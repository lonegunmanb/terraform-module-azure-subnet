variable "subnet_name" {
  type        = string
  description = "The name of the subnet. Changing this forces a new resource to be created."
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
  nullable    = false
}

variable "virtual_network" {
  type = object({
    id       = string
    name     = string
    location = string
  })
  description = <<-EOT
    The virtual network which to attach the subnet. Changing this forces some new resources to be created.
    id: The virtual NetworkConfiguration ID.
    name: The name of the virtual network.
    location: The location/region where the virtual network is created.
  EOT
  nullable    = false
  validation {
    condition     = var.virtual_network.id != null
    error_message = "`virtual_network.id` is required."
  }
  validation {
    condition     = var.virtual_network.name != null
    error_message = "`virtual_network.name` is required."
  }
  validation {
    condition     = var.virtual_network.location != null
    error_message = "`virtual_network.location` is required."
  }
}

variable "address_prefixes" {
  type        = list(string)
  description = "The address prefixes to use for the subnet."
  nullable    = false
  validation {
    condition     = length(var.address_prefixes) > 0
    error_message = "`address_prefixes` requires 1 item minimum, 0 got."
  }
}

variable "subnet_delegations" {
  type = list(object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  }))
  default     = null
  description = <<-EOT
    Details: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#delegation
    name: A name for this delegation.
    service_delegation:
      name: The name of service to delegate to. Possible values include
      actions: The name of service to delegate to. Possible values include
  EOT
  validation {
    condition     = var.subnet_delegations == null ? true : alltrue([for d in var.subnet_delegations : (d != null)])
    error_message = "`subnet_delegations`'s element cannot be null."
  }
  validation {
    condition     = var.subnet_delegations == null ? true : alltrue([for n in var.subnet_delegations.*.name : (n != null)])
    error_message = "`subnet_delegation.name` is required when `subnet_delegation` is not null."
  }
  validation {
    condition     = var.subnet_delegations == null ? true : alltrue([for d in var.subnet_delegations.*.service_delegation : (d != null)])
    error_message = "`subnet_delegation.service_delegation` is required when `subnet_delegation` is not null."
  }
  validation {
    condition     = var.subnet_delegations == null ? true : alltrue([for n in var.subnet_delegations.*.service_delegation.name : (n != null)])
    error_message = "`subnet_delegation.service_delegation.name` is required when `subnet_delegation` is not null."
  }
}

variable "enforce_private_link_endpoint_network_policies" {
  type        = bool
  default     = false
  description = "Enable or Disable network policies for the private link endpoint on the subnet. Setting this to `true` will **Disable** the policy and setting this to `false` will **Enable** the policy. Default value is `false`."
  nullable    = false
}

variable "enforce_private_link_service_network_policies" {
  type        = bool
  default     = false
  description = "Enable or Disable network policies for the private link service on the subnet. Setting this to `true` will **Disable** the policy and setting this to `false` will **Enable** the policy. Default value is `false`."
  nullable    = false
}

variable "service_endpoints" {
  type        = list(string)
  default     = null
  description = "The list of Service endpoints to associate with the subnet."
}

variable "service_endpoint_policy_ids" {
  type        = list(string)
  default     = null
  description = "The list of IDs of Service Endpoint Policies to associate with the subnet."
}

variable "new_route_table_name" {
  type        = string
  default     = null
  description = "The name of the new route table. Changing this forces a new route table to be created."
}

variable "route_table" {
  type = object({
    id   = string
    name = string
  })
  default     = null
  description = <<-EOT
    Leave this parameter null would create a new route table.
    id: The ID of the Route Table which should be associated with the Subnet. Changing this forces a new route table association to be created.
    name: The name of the route table. Changing this forces a new route table association to be created.
  EOT
  validation {
    condition     = var.route_table == null ? true : var.route_table.id != null
    error_message = "`route_table.id` is required when `route_table` is not null."
  }
}

variable "security_group" {
  type = object({
    id   = string
    name = string
  })
  default     = null
  description = <<-EOT
    Leave this parameter null would create a new Network Security Group.
    id: The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new association to be created.
    name: Specifies the name of the network security group. Changing this forces a new association to be created.
  EOT
  validation {
    condition     = var.security_group == null ? true : var.security_group.id != null
    error_message = "`security_group.id` is required when `security_group` is not null."
  }
  validation {
    condition     = var.security_group == null ? true : var.security_group.name != null
    error_message = "`security_group.name` is required when `security_group` is not null."
  }
}

variable "nat_gateway" {
  type = object({
    id = string
  })
  default     = null
  description = <<-EOT
    id: The ID of the NAT Gateway which should be associated with the Subnet. Changing this forces a new resource to be created.
  EOT
  validation {
    condition     = var.nat_gateway == null ? true : var.nat_gateway.id != null
    error_message = "`nat_gateway.id` is required when `nat_gateway` is not null."
  }
}

variable "new_network_security_group_name" {
  type        = string
  default     = null
  description = "Specifies the name of the new Network Security Group. Changing this forces a new resource to be created."
}

variable "new_network_security_group_tags" {
  type        = map(string)
  default     = null
  description = "A mapping of tags to assign to the Network Security Group."
}