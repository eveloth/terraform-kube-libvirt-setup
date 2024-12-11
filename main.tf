terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

locals {
  pool = "kube"
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "server_pool" {
  name = local.pool
  type = "dir"
  target {
    path = "/home/eveloth/libvirt/${local.pool}_pool"
  }
}

module "rocky_k_master" {
  source = "./modules/rocky"

  server_conf = {
    name    = "k-master"
    ip_addr = "192.168.122.40"
    memory  = 4096
    vcpu    = 4
  }
  pool        = local.pool
  cloud_image = "/home/eveloth/Downloads/Rocky-9-GenericCloud.latest.x86_64.qcow2"
}

module "rocky_k_worker1" {
  source = "./modules/rocky"

  server_conf = {
    name    = "k-worker1"
    ip_addr = "192.168.122.41"
    memory  = 2048
    vcpu    = 2
  }
  pool        = local.pool
  cloud_image = "/home/eveloth/Downloads/Rocky-9-GenericCloud.latest.x86_64.qcow2"
}

module "rocky_k_worker2" {
  source = "./modules/rocky"

  server_conf = {
    name    = "k-worker2"
    ip_addr = "192.168.122.42"
    memory  = 2048
    vcpu    = 2
  }
  pool        = local.pool
  cloud_image = "/home/eveloth/Downloads/Rocky-9-GenericCloud.latest.x86_64.qcow2"
}
