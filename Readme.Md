Azure Private Linux & Windows VM Module — Terraform Cloud Ready
📌 Overview

This module provisions private virtual machines (Linux or Windows) inside an existing Azure VNet with no public IP, designed for secure environments.
It automatically creates:

Network Security Group (NSG) with inbound rules

Private Network Interface (NIC)

VM (Linux or Windows) based on chosen OS type

Optional data disk attachment

🛠 Features

Select OS type: Linux or Windows

Private subnet only — no internet exposure

Customizable VM size, OS image, and inbound CIDR

Works with Terraform Cloud No-Code Provisioning

📋 Using in Terraform Cloud (No-Code)

Publish this module to your Terraform Cloud Private Registry.

From Terraform Cloud UI → Modules → Select this module → Provision Workspace.

Fill in variables:

Variable	Description	Example
vm_name	Name of the VM	my-vm
os_type	OS type (Linux or Windows)	Linux
vm_size	Azure VM size	Standard_B2s
resource_group_name	Existing RG name	rg-prod
location	Azure location	East US
subnet_id	ID of existing private subnet	/subscriptions/.../subnets/private
admin_username	Admin username	azureadmin
admin_password	Admin password (Windows only)	SecurePass@123
ssh_public_key	SSH key (Linux only)	ssh-rsa AAAA...
allowed_inbound_cidr	Allowed inbound CIDR	10.0.0.0/16
🚫 Why No Public IP?

Eliminates direct internet exposure

Access only via VPN, Bastion, or peering

Strongly recommended for production workloads

📂 Files

main.tf → VM creation (Linux & Windows)

variables.tf → Input variables

versions.tf → Required versions

outputs.tf → Outputs (Private IP)

README.md → Documentation

📦 Outputs

private_ip → Private IP address of the VM

🔒 Security Notes

Store passwords as sensitive variables in Terraform Cloud

Never commit credentials to code

Use Azure Bastion or private peering for remote access
