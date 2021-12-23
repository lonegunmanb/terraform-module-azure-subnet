provider "azurerm" {
  features {}
}

resource "random_pet" "id" {}

module "label" {
  source         = "registry.terraform.io/cloudposse/label/null"
  namespace      = "zjhe"
  name           = "subnet-module-${random_pet.id.id}"
  delimiter      = "-"
  label_key_case = "lower"
  tags           = {
    author = "zjhe"
  }
}

resource "azurerm_resource_group" "rg" {
  location = "eastus"
  name     = module.label.id
  tags     = module.label.tags
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  name                = "zjhe-vnet-module"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.label.tags
}

resource "azurerm_route_table" "rt" {
  location            = azurerm_resource_group.rg.location
  name                = "${module.label.id}-rt"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.label.tags
}

resource "azurerm_network_security_group" "nsg" {
  location            = azurerm_resource_group.rg.location
  name                = "example"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.label.tags
}

resource "azurerm_public_ip" "nat_ip" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = module.label.id
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.label.tags
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "private_nat_gw" {
  location            = azurerm_resource_group.rg.location
  name                = module.label.id
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_nat_gateway_public_ip_association" "association" {
  nat_gateway_id       = azurerm_nat_gateway.private_nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}

module "private" {
  depends_on                                     = [azurerm_route_table.rt]
  source                                         = "../../"
  address_prefixes                               = ["10.0.0.0/24"]
  resource_group_name                            = azurerm_resource_group.rg.name
  subnet_name                                    = "${module.label.id}-private"
  virtual_network                                = {
    id       = azurerm_virtual_network.vnet.id
    name     = azurerm_virtual_network.vnet.name
    location = azurerm_virtual_network.vnet.location
  }
  route_table                                    = {
    id = azurerm_route_table.rt.id
  }
  new_network_security_group_name                = "example1"
  new_network_security_group_tags                = module.label.tags
  nat_gateway                                    = {
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
  direction                   = "Inbound"
  name                        = "allow_public_subnet_inbound"
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
  depends_on          = [
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

resource "azurerm_linux_virtual_machine" "private" {
  name                  = "${module.label.id}-private"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_A1_v2"
  admin_username        = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.private_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("d:\\.ssh\\id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_id = data.azurerm_image.ubuntu_with_az.id
  identity {
    type = "SystemAssigned"
  }
}

module "public" {
  depends_on                      = [azurerm_route_table.rt]
  source                          = "../../"
  address_prefixes                = ["10.0.1.0/24"]
  resource_group_name             = azurerm_resource_group.rg.name
  subnet_name                     = "${module.label.id}-public"
  virtual_network                 = {
    id       = azurerm_virtual_network.vnet.id
    name     = azurerm_virtual_network.vnet.name
    location = azurerm_virtual_network.vnet.location
  }
  route_table                     = {
    id = azurerm_route_table.rt.id
  }
  new_network_security_group_name = "example2"
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

data "azurerm_image" "ubuntu_with_az" {
  resource_group_name = "packer"
  name                = "UbuntuServerWithAzCli"
}

resource "azurerm_public_ip" "public" {
  allocation_method   = "Dynamic"
  location            = azurerm_resource_group.rg.location
  name                = "${module.label.id}-public"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_interface" "public_nic" {
  depends_on          = [module.public]
  location            = azurerm_resource_group.rg.location
  name                = "${module.label.id}-public-nic"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "public"
    subnet_id                     = module.public.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id
  }
}

resource "azurerm_linux_virtual_machine" "public" {
  name                  = "${module.label.id}-public"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_A1_v2"
  admin_username        = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.public_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("d:\\.ssh\\id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_id = data.azurerm_image.ubuntu_with_az.id
  identity {
    type = "SystemAssigned"
  }

  provisioner "file" {
    connection {
      host        = self.public_ip_addresses[0]
      type        = "ssh"
      user        = "adminuser"
      agent       = false
      private_key = file("d:/.ssh/id_rsa")
    }
    source      = "d:/.ssh/id_rsa"
    destination = "/home/adminuser/.ssh/id_rsa"
  }
  provisioner "remote-exec" {
    connection {
      host        = self.public_ip_addresses[0]
      type        = "ssh"
      user        = "adminuser"
      agent       = false
      private_key = file("d:/.ssh/id_rsa")
    }
    inline = ["sudo chmod 600 /home/adminuser/.ssh/id_rsa"]
  }
}

output "public_ip" {
  value = azurerm_linux_virtual_machine.public.public_ip_address
}

output "private_ip" {
  value = azurerm_linux_virtual_machine.private.private_ip_address
}

output "nat_ip" {
  value = azurerm_public_ip.nat_ip.ip_address
}