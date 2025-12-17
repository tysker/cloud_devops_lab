resource "linode_instance" "jump" {
  label  = "cloud-devops-jump"
  region = var.region
  type   = var.instance_type
  image  = "linode/ubuntu22.04"

  private_ip = true
}
