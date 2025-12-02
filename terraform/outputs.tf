# Outputs

locals {
  server_ip = (
    var.provider_choice == "digitalocean" ? (
      length(digitalocean_droplet.wealthpath) > 0 ? digitalocean_droplet.wealthpath[0].ipv4_address : null
    ) : var.provider_choice == "hetzner" ? (
      length(hcloud_server.wealthpath) > 0 ? hcloud_server.wealthpath[0].ipv4_address : null
    ) : var.provider_choice == "aws" ? (
      length(aws_eip.wealthpath) > 0 ? aws_eip.wealthpath[0].public_ip : null
    ) : null
  )
  
  # Auto-generate sslip.io domain from IP
  sslip_domain = local.server_ip != null ? "${replace(local.server_ip, ".", "-")}.sslip.io" : null
  
  # Use custom domain if provided, otherwise sslip.io
  app_domain = var.domain != "" ? var.domain : local.sslip_domain
}

output "server_ip" {
  description = "Public IP address of the server"
  value       = local.server_ip
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = local.server_ip != null ? "ssh -i ~/.ssh/wealthpath_key ${var.provider_choice == "aws" ? "ubuntu" : "root"}@${local.server_ip}" : null
}

output "app_url" {
  description = "Application URL (with SSL)"
  value       = local.app_domain != null ? "https://${local.app_domain}" : null
}

output "app_domain" {
  description = "Domain name for the app"
  value       = local.app_domain
}

output "provider" {
  description = "Cloud provider used"
  value       = var.provider_choice
}

output "next_steps" {
  description = "What to do next"
  value = <<-EOF
    
    ✅ Server created on ${upper(var.provider_choice)}!
    
    Next steps:
    
    1. Wait 3-5 minutes for Docker build to complete
    
    2. SSH into server:
       ssh -i ~/.ssh/wealthpath_key ${var.provider_choice == "aws" ? "ubuntu" : "root"}@${local.server_ip}
    
    3. Check deployment status:
       cat /var/log/wealthpath-setup.log
       ${var.provider_choice == "aws" ? "sudo " : ""}docker ps
    
    4. Access your app: https://${local.app_domain}
    
    ${var.domain != "" ? "Note: Make sure your domain DNS A record points to ${local.server_ip}" : "Using free SSL via sslip.io - no DNS setup needed!"}
    
  EOF
}
