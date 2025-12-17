output "jump_public_ip" {
  description = "Public IPv4 address of the jump server"
  value       = tolist(module.jump.ipv4)[0]
}

output "jump_private_ip" {
  description = "Private IPv4 address of the jump server"
  value       = module.jump.private_ip
}

output "app_private_ip" {
  description = "Private IPv4 address of the application server"
  value       = module.app.private_ip
}

output "monitoring_private_ip" {
  description = "Private IPv4 address of the monitoring server"
  value       = module.monitoring.private_ip
}
