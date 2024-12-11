variable "server_conf" {
  type = object({
    name    = string
    ip_addr = string
    memory  = number
    vcpu    = number
  })

  default = {
    name    = "myvm"
    ip_addr = "192.168.122.40"
    memory  = 2048
    vcpu    = 2
  }
}

variable "pool" {
  type    = string
  default = "terraform"
}

variable "cloud_image" {
  type    = string
  default = "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2"
}
