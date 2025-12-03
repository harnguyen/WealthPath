# WealthPath Terraform (AWS)

Deploy WealthPath to AWS EC2 with a single command.

## Prerequisites

1. [Terraform](https://terraform.io/downloads) installed
2. AWS credentials configured:
   ```bash
   aws configure
   # Or export environment variables:
   export AWS_ACCESS_KEY_ID="xxx"
   export AWS_SECRET_ACCESS_KEY="xxx"
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
| `aws_region` | AWS region | `us-east-1` |
| `aws_instance_type` | EC2 instance type | `t3.small` |
| `ssh_public_key` | Your SSH public key | Required |
| `domain` | Custom domain (optional) | Auto sslip.io |
| `use_ssl` | Enable HTTPS | `true` |
| `use_zerossl` | Use ZeroSSL (for DuckDNS) | `false` |
| `admin_email` | Email for SSL certs | Required if ZeroSSL |

## Instance Types

| Type | RAM | Cost | Use Case |
|------|-----|------|----------|
| `t3.micro` | 1GB | Free tier | Testing |
| `t3.small` | 2GB | ~$15/mo | Production (recommended) |
| `t3.medium` | 4GB | ~$30/mo | High traffic |

## Outputs

After `terraform apply`:
- `server_ip` - EC2 public IP
- `ssh_command` - SSH connection command
- `app_url` - Application URL

## Destroy

```bash
terraform destroy
```
