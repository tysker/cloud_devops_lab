terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 3.6"
    }
  }
}

provider "linode" {
  token = var.linode_token
}
