module "jump" {
  source = "./modules/compute"

  label           = "${var.project_name}-${var.environment}-jump"
  region          = var.region
  instance_type   = var.instance_type_1gb
  image           = var.image
  authorized_keys = [chomp(file(var.ssh_public_key_path))]
}

module "app" {
  source = "./modules/compute"

  label           = "${var.project_name}-${var.environment}-app"
  region          = var.region
  instance_type   = var.instance_type_2gb
  image           = var.image
  authorized_keys = [chomp(file(var.ssh_public_key_path))]
}

module "monitoring" {
  source = "./modules/compute"

  label           = "${var.project_name}-${var.environment}-monitoring"
  region          = var.region
  instance_type   = var.instance_type_2gb
  image           = var.image
  authorized_keys = [chomp(file(var.ssh_public_key_path))]
}

resource "linode_firewall" "jump_fw" {
  label = "${var.project_name}-jump-fw"

  inbound {
    label    = "allow-ssh" # Allows ssh from anywhere (restrict later)
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound_policy  = "DROP"   # Drops evertying else 
  outbound_policy = "ACCEPT" # Allows outbound traffic

  linodes = [module.jump.id]
}

resource "linode_firewall" "app_fw" {
  label = "${var.project_name}-app-fw"

  inbound {
    label    = "allow-private-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["${module.jump.private_ip}/32"]
  }

  inbound {
    label    = "allow-private-app-traffic"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1-65535"
    ipv4     = ["192.168.0.0/16"]
  }

  inbound {
    label    = "allow-https"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "443"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound {
    label    = "allow-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  linodes = [module.app.id]
}

resource "linode_firewall" "monitoring_fw" {
  label = "${var.project_name}-monitoring-fw"

  inbound {
    label    = "allow-private-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["${module.jump.private_ip}/32"]
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

  linodes = [module.monitoring.id]
}
