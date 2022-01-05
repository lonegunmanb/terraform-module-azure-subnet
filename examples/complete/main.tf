provider "azurerm" {
  features {}
}

module "label" {
  source         = "registry.terraform.io/cloudposse/label/null"
  namespace      = var.namespace
  name           = "subnet-module"
  delimiter      = "-"
  label_key_case = "lower"
  tags = {
    author = var.namespace
  }
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = module.label.id
  tags     = module.label.tags
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.0.0.0/16"]
  name                = "${module.label.id}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = module.label.tags
}

resource "azurerm_route_table" "rt" {
  location            = azurerm_resource_group.rg.location
  name                = "${module.label.id}-rt"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.label.tags
}

resource "azurerm_network_security_group" "private-nsg" {
  location            = azurerm_resource_group.rg.location
  name                = "${module.label.id}-private-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.label.tags
}

resource "azurerm_nat_gateway" "private_nat_gw" {
  location            = azurerm_resource_group.rg.location
  name                = module.label.id
  resource_group_name = azurerm_resource_group.rg.name
}

module "private" {
  depends_on          = [azurerm_route_table.rt]
  source              = "../../"
  address_prefixes    = ["10.0.0.0/24"]
  resource_group_name = azurerm_resource_group.rg.name
  subnet_name         = "${module.label.id}-private"
  virtual_network = {
    id       = azurerm_virtual_network.vnet.id
    name     = azurerm_virtual_network.vnet.name
    location = azurerm_virtual_network.vnet.location
  }
  security_group = {
    id   = azurerm_network_security_group.private-nsg.id
    name = azurerm_network_security_group.private-nsg.name
  }
  nat_gateway = {
    id = azurerm_nat_gateway.private_nat_gw.id
  }
}

resource "azurerm_network_security_rule" "allow_public_subnet_tcp_inbound_to_private" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "allow_public_subnet_inbound"
  network_security_group_name = module.private.security_group_name
  priority                    = 4093
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  destination_address_prefix  = "VirtualNetwork"
  destination_port_range      = "*"
  timeouts {
    read = "1m"
  }
}

resource "azurerm_network_security_rule" "allow_public_subnet_tcp_outbound_from_private" {
  access                      = "Allow"
  direction                   = "Outbound"
  name                        = "allow_public_subnet_outbound"
  network_security_group_name = module.private.security_group_name
  priority                    = 4092
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  destination_address_prefix  = "VirtualNetwork"
  destination_port_range      = "*"
  timeouts {
    read = "1m"
  }
}

resource "azurerm_network_interface" "private_nic" {
  depends_on = [
    module.private,
  ]
  location            = azurerm_resource_group.rg.location
  name                = "${module.label.id}-private-nic"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "private"
    subnet_id                     = module.private.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

module "public" {
  depends_on          = [azurerm_route_table.rt]
  source              = "../../"
  address_prefixes    = ["10.0.1.0/24"]
  resource_group_name = azurerm_resource_group.rg.name
  subnet_name         = "${module.label.id}-public"
  virtual_network = {
    id       = azurerm_virtual_network.vnet.id
    name     = azurerm_virtual_network.vnet.name
    location = azurerm_virtual_network.vnet.location
  }
  route_table = {
    id   = azurerm_route_table.rt.id
    name = azurerm_route_table.rt.name
  }
  new_network_security_group_name = "${module.label.id}-public-nsg"
  new_network_security_group_tags = module.label.tags
}

resource "azurerm_network_security_rule" "allow_internet_to_public" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "allow_internet_to_public"
  network_security_group_name = module.public.security_group_name
  priority                    = 4095
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  source_address_prefix       = "Internet"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  timeouts {
    read = "1m"
  }
}

resource "azurerm_network_security_rule" "allow_internet_from_public" {
  access                      = "Allow"
  direction                   = "Outbound"
  name                        = "allow_internet_from_public"
  network_security_group_name = module.public.security_group_name
  priority                    = 4094
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  destination_address_prefix  = "Internet"
  destination_port_range      = "*"
  timeouts {
    read = "1m"
  }
}