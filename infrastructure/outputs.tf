output "test_public_ip" {
  description = ""
  value       = linode_instance.test.ipv4
}

output "test_private_ip" {
  description = ""
  value       = linode_instance.test.private_ip_address
}
