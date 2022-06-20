variable "cpus" {
  type    = string
  default = "2"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"
}

variable "ram" {
  type    = string
  default = "2048"
}

variable "version" {
  type    = string
  default = "0"
}



source "virtualbox-iso" "DHCP" {
    boot_command = [
    "c<wait>",
    "set gfxpayload=keep<enter>",
    "linux /casper/vmlinuz ",
    "\"ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/\" ",
    "quiet splash nomodeset autoinstall ---<enter>",
    "initrd /casper/initrd<enter>",
    "boot<enter>"
  ]
  boot_wait = "2s"
  disk_size = 10000
  export_opts = [
    "--manifest",
    "--vsys", "0",
    "--description", "DHCP"
  ]
  format                 = "ova"
  guest_additions_mode   = "disable"
  guest_os_type          = "Ubuntu_64"
  hard_drive_interface   = "sata"
  http_directory         = "http"
  iso_checksum           = "${var.iso_checksum}"
  iso_urls               = ["https://releases.ubuntu.com/20.04/ubuntu-20.04.4-live-server-amd64.iso"]
  memory                 = 8096
  cpus = 4
  output_directory       = "build"
  output_filename        = "DHCP"
  shutdown_command       = "echo 'admin' | sudo -S shutdown -P now"
  ssh_handshake_attempts = "300"
  ssh_password           = "ubuntu"
  ssh_pty                = true
  ssh_timeout            = "1800s"
  ssh_username           = "admin"
  vboxmanage             = [
    ["modifyvm", "{{.Name}}", "--firmware", "EFI"], 
    ["modifyvm", "{{ .Name }}", "--uart1", "off" ]
  ]
}

build {
  sources = ["sources.virtualbox-iso.DHCP"]
  provisioner "file" {
    source      = "scripts/isc-dhcp-server"
    destination = "isc-dhcp-server"
  }
  provisioner "file" {
    source      = "scripts/dhcpd6.conf"
    destination = "dhcpd6.conf"
  }
  provisioner "file" {
    source      = "scripts/ipv6.sh"
    destination = "ipv6.sh"
  }
  provisioner "file" {
    source      = "scripts/dhcpd.conf"
    destination = "dhcpd.conf"
  }
  provisioner "file" {
    source      = "scripts/netconf.service"
    destination = "netconf.service"
  }
  provisioner "file" {
    source      = "scripts/startup.sh"
    destination = "startup.sh"
  }
  provisioner "shell" {
    script = "scripts/install.sh"
    valid_exit_codes = [0, 1]
  }
} 