# WealthPath Terraform (DigitalOcean)

Deploy WealthPath to DigitalOcean with a single command.

## Prerequisites

1. [Terraform](https://terraform.io/downloads) installed (v1.0+)
2. DigitalOcean account and API token:
   ```bash
   # Get your token from: https://cloud.digitalocean.com/account/api/tokens
   export DIGITALOCEAN_TOKEN="your-api-token-here"
   ```

## Quick Start

```bash
cd terraform

# Copy and edit variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your SSH key and preferences

# Deploy
terraform init
terraform apply
```

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `droplet_name` | Name of the droplet | `wealthpath` |
| `region` | DigitalOcean region | `sgp1` |
| `size` | Droplet size | `s-1vcpu-2gb` |
| `ssh_public_key` | Your SSH public key | Required |
| `domain` | Custom domain (optional) | Auto sslip.io |
| `use_ssl` | Enable HTTPS | `true` |
| `enable_reserved_ip` | Static IP address | `true` |
| `admin_email` | Email for SSL certs | `admin@example.com` |

## Droplet Sizes

| Size | vCPUs | RAM | SSD | Cost |
|------|-------|-----|-----|------|
| `s-1vcpu-512mb` | 1 | 512MB | 10GB | $4/mo |
| `s-1vcpu-1gb` | 1 | 1GB | 25GB | $6/mo |
| `s-1vcpu-2gb` | 1 | 2GB | 50GB | $12/mo (recommended) |
| `s-2vcpu-2gb` | 2 | 2GB | 60GB | $18/mo |
| `s-2vcpu-4gb` | 2 | 4GB | 80GB | $24/mo |

## Regions

| Code | Location |
|------|----------|
| `nyc1`, `nyc3` | New York |
| `sfo3` | San Francisco |
| `sgp1` | Singapore |
| `lon1` | London |
| `fra1` | Frankfurt |
| `ams3` | Amsterdam |
| `blr1` | Bangalore |
| `syd1` | Sydney |

## Outputs

After `terraform apply`:
- `server_ip` - Droplet public IP
- `ssh_command` - SSH connection command
- `app_url` - Application URL
- `droplet_id` - DigitalOcean droplet ID

## Deploy Application

After infrastructure is created:

```bash
# SSH into the server
ssh root@$(terraform output -raw server_ip)

# Or deploy with Ansible
cd ../ansible
ansible-playbook -i "$(cd ../terraform && terraform output -raw server_ip)," playbook.yml
```

## Destroy

```bash
terraform destroy
```
