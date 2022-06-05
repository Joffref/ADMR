variable "ssh_user" {
  type      = string
  default   = "packer"
  sensitive = true
}

variable "ssh_pass" {
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

variable "domain" {
  type    = string
  default = "local"
}

variable "hostname" {
  type    = string
  default = "Supervision"
}

source "virtualbox-iso" "supervision" {
    boot_command = [
    "<enter><wait><f6><esc><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "/install/vmlinuz<wait>",
    " initrd=/install/initrd.gz<wait>",
    " auto<wait>",
    " console-setup/ask_detect=false<wait>",
    " console-setup/layoutcode=us<wait>",
    " console-setup/modelcode=pc105<wait>",
    " debconf/frontend=noninteractive<wait>",
    " debian-installer=fr_FR<wait>",
    " fb=false<wait>",
    " kbd-chooser/method=fr<wait>",
    " keyboard-configuration/layout=FR<wait>",
    " keyboard-configuration/variant=FR<wait>",
    " locale=fr_FR<wait>",
    " netcfg/get_domain={{user `domain`}}<wait>",
    " netcfg/get_hostname={{user `hostname`}}<wait>",
    " grub-installer/bootdev=/dev/sda<wait>",
    " noapic<wait>",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
    " -- <wait>",
    " <enter><wait>"
  ]
  format = "ova"
  guest_additions_mode = "upload"
  headless = false
  http_directory = "http"
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
  sources = ["sources.virtualbox-iso.supervision"]
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