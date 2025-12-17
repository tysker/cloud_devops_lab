output "jump_public_ip" {
  description = "Public IPv4 address of the jump server"
  value       = tolist(linode_instance.jump.ipv4)[0]
}

output "jump_private_ip" {
  description = "Private IPv4 address of the jump server"
  value       = linode_instance.jump.private_ip_address
}

output "app_private_ip" {
  description = "Private IPv4 address of the application server"
  value       = linode_instance.app.private_ip_address
}
