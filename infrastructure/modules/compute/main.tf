resource "linode_instance" "this" {
  label  = var.label
  region = var.region
  type   = var.instance_type
  image  = var.image

  authorized_keys = var.authorized_keys
  private_ip      = true
}
