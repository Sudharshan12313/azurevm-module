output "vm_private_ips" {
  value = {
    for name, nic in azurerm_network_interface.vm_nic :
    name => nic.ip_configuration[0].private_ip_address
  }
}
