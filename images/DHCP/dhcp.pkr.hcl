variable "ssh_username" {
  type      = string
  default   = "packer"
  sensitive = true
}

variable "ssh_password" {
  type      = string
  default   = "packer"
  sensitive = true
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "cpus" {
  type    = string
  default = "2"
}


source "virtualbox-iso" "dhcp" {
  guest_os_type    = "Ubuntu_64"
  vm_name          = "ldap"
  iso_url          = "http://releases.ubuntu.com/18.04/ubuntu-18.04.6-live-server-amd64.iso"
  iso_checksum     = "sha256:6c647b1ab4318e8c560d5748f908e108be654bad1e165f7cf4f3c1fc43995934"
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  disk_size        = "10000"
  nic_type         = "82540EM"
  memory           = var.memory
  cpus             = var.cpus
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
}

build {
  sources = ["sources.virtualbox-iso.dhcp"]
  provisioner "shell" {
    script = "scripts/install.sh"
  }

  provisioner "file" {
    source      = "scripts/isc-dhcp-server"
    destination = "/etc/default/isc-dhcp-server"
  }
  provisioner "file" {
    source      = "scripts/dhcpd.conf"
    destination = "/etc/dhcp/dhcpd.conf"
  }
  post-processor "shell-local" {
    inline = ["sudo systemctl restart isc-dhcp-server"]
  }
} 