# WealthPath Infrastructure
# Supports: DigitalOcean, Hetzner, AWS

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Variables
variable "provider_choice" {
  description = "Cloud provider: digitalocean, hetzner, or aws"
  type        = string
  default     = "aws"
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ssh_key_name" {
  description = "Name of SSH key"
  type        = string
  default     = "wealthpath-key"
}

variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
}

variable "domain" {
  description = "Domain name for the app (e.g., wealthpath.duckdns.org)"
  type        = string
  default     = ""
}

variable "use_ssl" {
  description = "Enable HTTPS/SSL (set false for domains with DNS issues)"
  type        = bool
  default     = true
}

variable "region" {
  description = "Region for deployment"
  type        = string
  default     = "nyc1" # DO: nyc1, sfo1, etc. Hetzner: nbg1, fsn1, hel1
}

# Local variables
locals {
  app_name = "wealthpath"
}

