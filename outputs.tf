output "vm_private_ips" {
  description = "Private IP addresses of all VMs"
  value       = azurerm_network_interface.nic[*].private_ip_address
}
