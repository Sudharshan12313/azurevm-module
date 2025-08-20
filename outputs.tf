output "linux_vm_private_ip" {
  description = "Private IP of the Linux VM"
  value       = azurerm_network_interface.linux_nic.private_ip_address
}

output "windows_vm_private_ip" {
  description = "Private IP of the Windows VM"
  value       = azurerm_network_interface.windows_nic.private_ip_address
}
