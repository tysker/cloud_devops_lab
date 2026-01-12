variable "linode_token" {
  description = "Linode API token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Linode region"
  type        = string
  default     = "eu-central"
}

variable "instance_type_1gb" {
  description = "Linode instance type 1GB ram"
  type        = string
  default     = "g6-nanode-1"
}

variable "instance_type_2gb" {
  description = "Linode instance type 2GB ram"
  type        = string
  default     = "g6-standard-1"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used to access servers"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "cloud-devops"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "image" {
  description = "Base image for Linode instances"
  type        = string
  default     = "linode/ubuntu22.04"
}
