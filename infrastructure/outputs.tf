output "test_public_ip" {
  description = "Public IPv4 address of the test Linode instance"
  value       = tolist(linode_instance.test.ipv4)[0]
}

output "test_private_ip" {
  description = "Private IPv4 address of the test Linode instance used for internal networking"
  value       = linode_instance.test.private_ip_address
}
