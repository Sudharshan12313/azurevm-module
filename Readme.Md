Private Linux & Windows VM Module (Azure) — Terraform Cloud Ready
📌 Overview
This module provisions private virtual machines (Linux or Windows) inside an existing Azure VNet without a public IP, suitable for secure environments.
It automatically creates:

Azure Network Security Group (NSG)

Private Network Interface (NIC)

VM based on OS type (Linux or Windows)

Optional data disk attachment

🛠 Supported Features
Choose OS type (Linux or Windows)

Private subnet only (no public exposure)

Auto-attached NSG with allowed inbound CIDR range

VM sizes, OS images, and disks fully configurable from Terraform Cloud UI

Works with Terraform Cloud No-Code Provisioning

📋 Usage in Terraform Cloud No-Code Provisioning
When you publish this module to the Terraform Cloud private registry:

Go to:
Terraform Cloud → Modules → Your Private Registry → Click this module → Provision Workspace

Fill in Variables in the UI:

Variable	Description	Example
vm_name	Name of the VM	my-linux-vm
os_type	Choose OS	Linux or Windows
vm_size	Azure VM Size	Standard_B2s
resource_group_name	Existing RG name	rg-prod
location	Azure location	East US
subnet_id	ID of private subnet	/subscriptions/.../subnets/my-private-subnet
admin_username	Admin username	azureadmin
admin_password	Admin password (Windows only)	SecurePass@123
ssh_public_key	SSH public key (Linux only)	ssh-rsa AAAA...
allowed_inbound_cidr	CIDR allowed to access VM	10.0.0.0/16

🚫 Why No Public IP?
Improves security by avoiding direct internet exposure

Access only via private network peering, VPN, or Bastion

Recommended for production workloads

📂 Module Structure
scss
Copy
Edit
main.tf        → VM creation (Linux & Windows)
variables.tf   → Input variables
outputs.tf     → Outputs (Private IP)
README.md      → Documentation (this file)
📤 Example Variables for No-Code Provisioning
hcl
Copy
Edit
vm_name              = "app-server"
os_type              = "Linux"
vm_size              = "Standard_B2s"
resource_group_name  = "rg-prod"
location             = "East US"
subnet_id            = "/subscriptions/xxx/resourceGroups/rg-prod/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/private-subnet"
admin_username       = "azureadmin"
ssh_public_key       = "ssh-rsa AAAA..."
allowed_inbound_cidr = "10.0.0.0/16"
📦 Outputs

private_ip → VM private IP address

🔒 Security Notes
Store passwords in Terraform Cloud sensitive variables

Never hardcode credentials in .tf files

Use Azure Bastion or private peering for remote access
