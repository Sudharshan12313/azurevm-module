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

# New VMs for this run
variable "new_vms" {
  description = "List of new VMs to add in this run (append-only model)"
  type = list(object({
    name    = string
    os_type = string # linux or windows
    size    = string
  }))
  default = []
  validation {
    condition     = alltrue([for vm in var.new_vms : contains(["linux", "windows"], vm.os_type)])
    error_message = "Each VM os_type must be either 'linux' or 'windows'."
  }
}

# TF Cloud remote state config
variable "tfcloud_org" {
  description = "Terraform Cloud organization name"
  type        = string
}

variable "tfcloud_workspace" {
  description = "Terraform Cloud workspace name (same as this one)"
  type        = string
}
