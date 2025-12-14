# DigitalOcean Resources

# SSH Key
resource "digitalocean_ssh_key" "wealthpath" {
  name       = var.ssh_key_name
  public_key = var.ssh_public_key
}

# Droplet (VM Instance)
resource "digitalocean_droplet" "wealthpath" {
  name     = var.droplet_name
  region   = var.region
  size     = var.size
  image    = var.image
  ssh_keys = [digitalocean_ssh_key.wealthpath.fingerprint]

  tags = [local.app_name, "production"]

  # No user_data needed - Ansible handles all provisioning
  # Ubuntu 24.04 has Python3 pre-installed for Ansible

  lifecycle {
    create_before_destroy = true
  }
}

# Firewall
resource "digitalocean_firewall" "wealthpath" {
  name        = "${var.droplet_name}-firewall"
  droplet_ids = [digitalocean_droplet.wealthpath.id]

  # SSH
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # HTTP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # HTTPS
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # All outbound traffic
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# Reserved IP (Static IP)
resource "digitalocean_reserved_ip" "wealthpath" {
  count  = var.enable_reserved_ip ? 1 : 0
  region = var.region
}

resource "digitalocean_reserved_ip_assignment" "wealthpath" {
  count      = var.enable_reserved_ip ? 1 : 0
  ip_address = digitalocean_reserved_ip.wealthpath[0].ip_address
  droplet_id = digitalocean_droplet.wealthpath.id
}

