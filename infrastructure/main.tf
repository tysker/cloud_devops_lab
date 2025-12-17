resource "linode_instance" "jump" {
  label  = "cloud-devops-jump"
  region = var.region
  type   = var.instance_type
  image  = "linode/ubuntu22.04"

  authorized_keys = [chomp(file(var.ssh_public_key_path))]

  private_ip = true
}

resource "linode_instance" "app" {
  label  = "cloud-devops-app"
  region = var.region
  type   = var.instance_type
  image  = "linode/ubuntu22.04"

  authorized_keys = [chomp(file(var.ssh_public_key_path))]


  private_ip = true
}

resource "linode_instance" "monitoring" {
  label  = "cloud-devops-monitoring"
  region = var.region
  type   = var.instance_type
  image  = "linode/ubuntu22.04"

  authorized_keys = [chomp(file(var.ssh_public_key_path))]

  private_ip = true
}

resource "linode_firewall" "jump_fw" {
  label = "cloud-devops-jump-fw"

  inbound {
    label    = "allow-ssh" # Allows ssh from anywhere (restrict later)
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound_policy  = "DROP"   # Drops evertying else 
  outbound_policy = "ACCEPT" # Allows outbound traffic

  linodes = [linode_instance.jump.id]
}

resource "linode_firewall" "app_fw" {
  label = "cloud-devops-app-fw"

  inbound {
    label    = "allow-private-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["${linode_instance.jump.private_ip_address}/32"]
  }

  inbound {
    label    = "allow-private-app-traffic"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1-65535"
    ipv4     = ["192.168.0.0/16"]
  }

  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  linodes = [linode_instance.app.id]
}

resource "linode_firewall" "monitoring_fw" {
  label = "cloud-devops-monitoring-fw"

  inbound {
    label    = "allow-private-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["${linode_instance.jump.private_ip_address}/32"]
  }

  inbound {
    label    = "allow-private-monitoring-traffic"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1-65535"
    ipv4     = ["192.168.0.0/16"]
  }

  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  linodes = [linode_instance.monitoring.id]
}
