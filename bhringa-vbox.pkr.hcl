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

variable "source-checksum" {
  type    = string
  default = "sha256:"
}

variable "source-password" {
  type      = string
  default   = "Pass@word1"
  sensitive = true
}

source "virtualbox-ovf" "bhringa-vbox" {
  source_path = "${var.source-path}"
  checksum    = "${var.source-checksum}"

  ssh_username = "user1"
  ssh_password = "${var.source-password}"
  ssh_timeout  = "20m"

  shutdown_command = "echo ${var.source-password} | sudo -S poweroff"

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

  # The output file should be called kutti-vbox.ova
  vm_name = "bhringa-vbox"

  headless = true
}

build {
  sources = [
    "sources.virtualbox-ovf.bhringa-vbox"
  ]

  provisioner "shell" {
    # The 10-setup-dev-env script sets up:
    #   - man and linux base manpages
    #   - llvm, lldb, clang
    #   - kernel headers, and bpf-related libraries
    #   - iproute2
    #   - bpftool
    #   - make and codeblocks IDE
    scripts = [
      "buildscripts/10-setup-dev-env.sh"
    ]
    # These scripts must be run with sudo access
    execute_command   = "echo ${build.Password} | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
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