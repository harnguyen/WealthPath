# WealthPath Infrastructure - AWS

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Variables
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
  description = "Enable HTTPS/SSL"
  type        = bool
  default     = true
}

variable "use_zerossl" {
  description = "Use ZeroSSL instead of Let's Encrypt (better for DuckDNS)"
  type        = bool
  default     = false
}

variable "admin_email" {
  description = "Admin email for SSL certificate registration"
  type        = string
  default     = "admin@example.com"
}

# Local variables
locals {
  app_name = "wealthpath"
}
