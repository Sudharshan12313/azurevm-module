# ------------------------------------------------------------------------------
# Core Network Resources
# ------------------------------------------------------------------------------

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "private" {
  name                 = "${var.prefix}-private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-rdp"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ------------------------------------------------------------------------------
# State-Driven Append Model for VMs
# ------------------------------------------------------------------------------

# Pull in existing VMs from tfstate (if any)
data "terraform_remote_state" "this" {
  backend = "remote"
  config = {
    organization = var.tfcloud_org
    workspaces = {
      name = var.tfcloud_workspace
    }
  }
}

locals {
  old_vms = try(data.terraform_remote_state.this.outputs.all_vms, [])
  all_vms = concat(local.old_vms, var.new_vms)
}

# ------------------------------------------------------------------------------
# NICs
# ------------------------------------------------------------------------------

resource "azurerm_network_interface" "vm_nic" {
  for_each            = { for vm in local.all_vms : vm.name => vm }
  name                = "${each.value.name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "vm_nic_assoc" {
  for_each                  = azurerm_network_interface.vm_nic
  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# ------------------------------------------------------------------------------
# Linux VMs
# ------------------------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each = { for vm in local.all_vms : vm.name => vm if vm.os_type == "linux" }

  name                = each.value.name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = each.value.size
  admin_username      = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

# ------------------------------------------------------------------------------
# Windows VMs
# ------------------------------------------------------------------------------

resource "azurerm_windows_virtual_machine" "windows_vm" {
  for_each = { for vm in local.all_vms : vm.name => vm if vm.os_type == "windows" }

  name                = each.value.name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = each.value.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
