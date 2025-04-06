variable "vm-version" {
  type    = string
  default = "latest"
}

variable "vm-description" {
  type    = string
  default = "Bhringa Image"
}

variable "source-path" {
  type    = string
  default = "input/"
}

# You should use the key pair generated when the source
# Matsya image was created. Point to the key pair file.
variable "root-certificate" {
  # Path to key pair file used for identifying root user
  type    = string
  default = "keys/rootcert"
}

source "virtualbox-ovf" "bhringa-vbox" {
  source_path = "${var.source-path}"

  ssh_username = "root"
  ssh_private_key_file = "${var.root-certificate}"
  ssh_timeout  = "20m"

  shutdown_command = "poweroff"

  guest_additions_mode = "disable"

  # The disk needs to be imported in VDI
  # format. This will allow us to compact it after
  # finishing setup, thus reducing the size of the
  # final OVA. The disk is usually vsys 0, unit 13
  import_flags = [
    "--vsys",
    "0",
    "--unit",
    "13",
    "--disk",
    "output-bhringa-vbox/bhringa-vbox-disk001.vdi"
  ]

  # VirtualBox 7 requires localhostreachable attribute
  # set to "on" for accessing localhost when the VM is
  # connected to a NAT interface. See:
  # https://github.com/hashicorp/packer/issues/12118
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
    ["modifyvm", "{{.Name}}", "--vrde", "off"]
  ]

  # After all provisioners have run, and the VM has
  # been stopped, the following VBoxManage commands
  # are carried out. The first one compacts the VDI
  # hard disk, and the second one adds an icon to 
  # the VM image.
  vboxmanage_post = [
    [
      "modifyhd",
      "--compact",
      "output-bhringa-vbox/bhringa-vbox-disk001.vdi"
    ],
    [
      "modifyvm",
      "{{ .Name }}",
      "--iconfile",
      "attachments/icon/bhringa.png"
    ]
  ]

  # Ensure that MAC addresses are stripped at export
  export_opts = [
    "--manifest",
    "--options", "nomacs",
    "--vsys", "0",
    "--description", "${var.vm-description}",
    "--version", "${var.vm-version}"
  ]
  format = "ova"

  # The final output file should be called Bhringa-VERSION.ova
  vm_name = "Bhringa-${var.vm-version}"

  headless = true
}

build {
  sources = [
    "sources.virtualbox-ovf.bhringa-vbox"
  ]

  provisioner "shell" {
    scripts = [
      "buildscripts/10-setup-dev-env.sh",
      "buildscripts/20-set-hostname.sh",
      "buildscripts/40-stamp-release.sh",
      "buildscripts/50-pre-compact.sh"
    ]

    # Ensure the VM_VERSION variable.
    environment_vars = [
      "VM_VERSION=${var.vm-version}"
    ]
  }

  provisioner "file" {
    sources = [
      "attachments/vbox-filesystem/"
    ]

    destination = "/"
  }
}

packer {
  required_version = ">= 1.9.2"
  required_plugins {
      virtualbox = {
        version = "~> 1"
        source  = "github.com/hashicorp/virtualbox"
      }
  }
}