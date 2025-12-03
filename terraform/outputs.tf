# Outputs

locals {
  server_ip    = aws_eip.wealthpath.public_ip
  sslip_domain = "${replace(local.server_ip, ".", "-")}.sslip.io"
  app_domain   = var.domain != "" ? var.domain : local.sslip_domain
}

output "server_ip" {
  description = "Public IP address of the server"
  value       = local.server_ip
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh -i ~/.ssh/wealthpath_key ubuntu@${local.server_ip}"
}

output "app_url" {
  description = "Application URL"
  value       = var.use_ssl ? "https://${local.app_domain}" : "http://${local.app_domain}"
}

output "app_domain" {
  description = "Domain name for the app"
  value       = local.app_domain
}

output "next_steps" {
  description = "What to do next"
  value = <<-EOF
    
    ✅ Server created on AWS!
    
    Next steps:
    
    1. Wait 3-5 minutes for setup to complete
    
    2. SSH into server:
       ssh -i ~/.ssh/wealthpath_key ubuntu@${local.server_ip}
    
    3. Check deployment status:
       cat /var/log/wealthpath-setup.log
       sudo docker ps
    
    4. Access your app: ${var.use_ssl ? "https" : "http"}://${local.app_domain}
    
    ${var.domain != "" ? "Note: Make sure your domain DNS A record points to ${local.server_ip}" : "Using free SSL via sslip.io - no DNS setup needed!"}
    
  EOF
}
