# Azure Authentication
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block for the VNet"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "os_type" {
  description = "OS type to provision (linux or windows)"
  type        = string
}

variable "vm_size" {
  description = "VM size"
  type        = string
}

variable "admin_username" {
  description = "Admin username"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key (Linux only)"
  type        = string
  default     = null
}

variable "admin_password" {
  description = "Admin password (Windows only)"
  type        = string
  sensitive   = true
  default     = null
}

variable "allowed_cidr" {
  description = "CIDR range allowed to connect (SSH or RDP)"
  type        = string
}
