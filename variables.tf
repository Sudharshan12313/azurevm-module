variable "subscription_id" {
  description = "Azure Subscription ID where resources will be provisioned"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group to create"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "prefix" {
  description = "Prefix to use for resource naming"
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block for the Virtual Network"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.vnet_cidr))
    error_message = "The vnet_cidr must be a valid CIDR block."
  }
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.subnet_cidr))
    error_message = "The subnet_cidr must be a valid CIDR block."
  }
}


variable "admin_username" {
  description = "Admin username for all VMs"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for Linux VMs"
  type        = string
}

variable "admin_password" {
  description = "Admin password for Windows VMs"
  type        = string
  sensitive   = true
}

variable "vms" {
  description = "List of virtual machines to create (Linux and Windows)"
  type = list(object({
    name    = string
    os_type = string # linux or windows
    size    = string
  }))
  validation {
    condition     = alltrue([for vm in var.vms : contains(["linux", "windows"], vm.os_type)])
    error_message = "Each VM os_type must be either 'linux' or 'windows'."
  }
}
