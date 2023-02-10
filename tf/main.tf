terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "tls_private_key" "plumber" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
  rsa_bits    = "4096"
}

resource "local_sensitive_file" "private_key" {
  content              = tls_private_key.plumber.private_key_openssh
  filename             = "${path.module}/.ssh/id"
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "public_key" {
  content              = tls_private_key.plumber.public_key_openssh
  filename             = "${path.module}/.ssh/id.pub"
  directory_permission = "0700"
}

resource "digitalocean_ssh_key" "cyber_plumber" {
  name       = "Cyber Plumber SSH Key"
  public_key = tls_private_key.plumber.public_key_openssh
}

locals {
  region = "nyc3"
}

resource "digitalocean_vpc" "cyber_plumber" {
  name     = "${var.namespace}-network"
  region   = local.region
  ip_range = "192.168.1.0/24"
}

#
# Droplets
# https://slugs.do-api.dev/
#

resource "digitalocean_droplet" "command" {
  name      = "${var.namespace}-command"
  size      = "s-1vcpu-1gb"
  image     = "ubuntu-22-04-x64"
  region    = local.region
  vpc_uuid  = digitalocean_vpc.cyber_plumber.id
  ssh_keys  = [digitalocean_ssh_key.cyber_plumber.fingerprint]
  user_data = file("./scripts/command-user-data.sh")
}

resource "digitalocean_droplet" "jumpbox" {
  count     = 4
  name      = "${var.namespace}-jumpbox-${count.index}"
  size      = "s-1vcpu-1gb"
  image     = "ubuntu-22-04-x64"
  region    = local.region
  vpc_uuid  = digitalocean_vpc.cyber_plumber.id
  ssh_keys  = [digitalocean_ssh_key.cyber_plumber.fingerprint]
  user_data = file("./scripts/jumpbox-user-data.sh")
}

#
# Project
#

resource "digitalocean_project" "cyber_plumber" {
  name        = var.namespace
  description = "Resources for The Cyber Plumber's Handbook"
  purpose     = "Class project / Educational purposes"
  environment = "Development"
  resources = flatten([
    digitalocean_droplet.command.urn,
    digitalocean_droplet.jumpbox[*].urn,
  ])
}
