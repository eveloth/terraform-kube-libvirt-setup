data "template_file" "network_config" {
  template = file("${path.module}/config/network_config.cfg")

  vars = {
    ip_addr = var.server_conf.ip_addr
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}


#resource "libvirt_pool" "server_pool" {
#  name = var.pool
#  type = "dir"
#  target {
#    path = "/home/eveloth/libvirt/${var.pool}_pool"
#  }
#}

resource "libvirt_volume" "rocky" {
  name   = "rocky-${var.server_conf.name}.qcow2"
  pool   = var.pool
  source = var.cloud_image
  format = "qcow2"
}

resource "libvirt_volume" "disk" {
  name           = "disk-${var.server_conf.name}.qcow2"
  pool           = var.pool
  size           = 10740000000
  base_volume_id = libvirt_volume.rocky.id
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit-${var.server_conf.name}.iso"
  user_data      = templatefile("${path.module}/config/cloud_init.cfg", { hostname = var.server_conf.name })
  network_config = data.template_file.network_config.rendered
  pool           = var.pool
}

resource "libvirt_domain" "kube" {
  name      = var.server_conf.name
  memory    = var.server_conf.memory
  vcpu      = var.server_conf.vcpu
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.disk.id
    scsi      = "true"
  }

  network_interface {
    bridge = "virbr0"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}

