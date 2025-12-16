resource "linode_instance" "test" {
  label  = "tf-test-instance"
  region = var.region
  type   = var.instance_type
  image  = "linode/ubuntu22.04"

  private_ip = true
}
