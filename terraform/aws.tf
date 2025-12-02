# AWS Provider Configuration

provider "aws" {
  region = var.aws_region
  
  # Use credentials from ~/.aws/credentials or environment variables
  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
  
  # Skip validation if not using AWS
  skip_credentials_validation = var.provider_choice != "aws"
  skip_requesting_account_id  = var.provider_choice != "aws"
  skip_metadata_api_check     = var.provider_choice != "aws"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"  # 2GB RAM needed for Next.js build
}

# Get latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  count       = var.provider_choice == "aws" ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# SSH Key Pair
resource "aws_key_pair" "wealthpath" {
  count      = var.provider_choice == "aws" ? 1 : 0
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key
}

# Security Group
resource "aws_security_group" "wealthpath" {
  count       = var.provider_choice == "aws" ? 1 : 0
  name        = "${local.app_name}-sg"
  description = "Security group for WealthPath"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.app_name}-sg"
  }
}

# EC2 Instance
resource "aws_instance" "wealthpath" {
  count                  = var.provider_choice == "aws" ? 1 : 0
  ami                    = data.aws_ami.ubuntu[0].id
  instance_type          = var.aws_instance_type
  key_name               = aws_key_pair.wealthpath[0].key_name
  vpc_security_group_ids = [aws_security_group.wealthpath[0].id]

  user_data = <<-EOF
    #!/bin/bash
    exec > /var/log/wealthpath-setup.log 2>&1
    set -ex
    
    # Update system
    apt update && apt upgrade -y
    
    # Install Docker
    curl -fsSL https://get.docker.com | sh
    
    # Install Docker Compose plugin
    apt install -y docker-compose-plugin git jq
    
    # Clone app
    mkdir -p /opt/wealthpath
    cd /opt/wealthpath
    git clone https://github.com/thanhhungg97/WealthPath.git .
    
    # Get public IP and create sslip.io domain
    PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
    SSLIP_DOMAIN=$(echo $PUBLIC_IP | tr '.' '-').sslip.io
    
    # Use custom domain if provided, otherwise use sslip.io
    CUSTOM_DOMAIN="${var.domain}"
    USE_SSL="${var.use_ssl}"
    
    if [ -n "$CUSTOM_DOMAIN" ]; then
      DOMAIN="$CUSTOM_DOMAIN"
    else
      DOMAIN="$SSLIP_DOMAIN"
    fi
    
    # Determine protocol
    if [ "$USE_SSL" = "true" ]; then
      PROTOCOL="https"
      CADDY_DOMAIN="$DOMAIN"
    else
      PROTOCOL="http"
      CADDY_DOMAIN="http://$DOMAIN"
    fi
    
    # Create Caddyfile
    cat > Caddyfile << CADDYEOF
$CADDY_DOMAIN {
    reverse_proxy /api/* backend:8080
    reverse_proxy /* frontend:3000
}
CADDYEOF
    
    # Generate secrets
    JWT_SECRET=$(openssl rand -hex 32)
    POSTGRES_PASSWORD=$(openssl rand -hex 16)
    
    # Create .env
    cat > .env << ENVEOF
POSTGRES_USER=wealthpath
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_DB=wealthpath
JWT_SECRET=$JWT_SECRET
DOMAIN=$DOMAIN
FRONTEND_URL=$PROTOCOL://$DOMAIN
ALLOWED_ORIGINS=$PROTOCOL://$DOMAIN
ENVEOF
    
    # Pull and run pre-built images (no build on server)
    docker compose -f docker-compose.deploy.yaml pull
    docker compose -f docker-compose.deploy.yaml up -d
    
    echo "WealthPath deployed successfully at $PROTOCOL://$DOMAIN"
  EOF

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = local.app_name
  }
}

# Elastic IP (optional but recommended)
resource "aws_eip" "wealthpath" {
  count    = var.provider_choice == "aws" ? 1 : 0
  instance = aws_instance.wealthpath[0].id
  domain   = "vpc"

  tags = {
    Name = "${local.app_name}-eip"
  }
}

