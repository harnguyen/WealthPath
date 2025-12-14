# Outputs

locals {
  server_ip    = var.enable_reserved_ip ? digitalocean_reserved_ip.wealthpath[0].ip_address : digitalocean_droplet.wealthpath.ipv4_address
  sslip_domain = "${replace(local.server_ip, ".", "-")}.sslip.io"
  app_domain   = var.domain != "" ? var.domain : local.sslip_domain
}

output "server_ip" {
  description = "Public IP address of the server"
  value       = local.server_ip
}

output "droplet_id" {
  description = "ID of the droplet"
  value       = digitalocean_droplet.wealthpath.id
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh root@${local.server_ip}"
}

output "app_url" {
  description = "Application URL"
  value       = var.use_ssl ? "https://${local.app_domain}" : "http://${local.app_domain}"
}

output "app_domain" {
  description = "Domain name for the app"
  value       = local.app_domain
}

output "droplet_region" {
  description = "Region of the droplet"
  value       = digitalocean_droplet.wealthpath.region
}

output "droplet_size" {
  description = "Size of the droplet"
  value       = digitalocean_droplet.wealthpath.size
}

output "next_steps" {
  description = "What to do next"
  value       = <<-EOF
    
    ✅ Server created on DigitalOcean!
    
    Next steps:
    
    1. SSH into server:
       ssh root@${local.server_ip}
    
    2. Deploy with Ansible:
       cd ansible && ansible-playbook -i '${local.server_ip},' playbook.yml
    
    3. Access your app: ${var.use_ssl ? "https" : "http"}://${local.app_domain}
    
    ${var.domain != "" ? "Note: Make sure your domain DNS A record points to ${local.server_ip}" : "Using free SSL via sslip.io - no DNS setup needed!"}
    
  EOF
}
