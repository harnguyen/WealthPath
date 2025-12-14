# WealthPath Infrastructure - DigitalOcean

terraform {
  required_version = ">= 1.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.34"
    }
  }
}

# DigitalOcean Provider
# Set DIGITALOCEAN_TOKEN environment variable
provider "digitalocean" {}

# Variables
variable "droplet_name" {
  description = "Name of the droplet"
  type        = string
  default     = "wealthpath"
}

variable "region" {
  description = "DigitalOcean region (e.g., nyc1, sfo3, sgp1, lon1)"
  type        = string
  default     = "sgp1"
}

variable "size" {
  description = "Droplet size (e.g., s-1vcpu-1gb, s-1vcpu-2gb, s-2vcpu-4gb)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "image" {
  description = "Droplet image (OS)"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "ssh_key_name" {
  description = "Name for the SSH key in DigitalOcean"
  type        = string
  default     = "wealthpath-key"
}

variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
}

variable "domain" {
  description = "Domain name for the app (e.g., wealthpath.example.com)"
  type        = string
  default     = ""
}

variable "use_ssl" {
  description = "Enable HTTPS/SSL"
  type        = bool
  default     = true
}

variable "admin_email" {
  description = "Admin email for SSL certificate registration"
  type        = string
  default     = "admin@example.com"
}

variable "enable_reserved_ip" {
  description = "Enable reserved (static) IP address"
  type        = bool
  default     = true
}

# Local variables
locals {
  app_name = "wealthpath"
}
