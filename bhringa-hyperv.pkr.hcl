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

source "hyperv-vmcx" "bhringa-hyperv" {
  clone_from_vmcx_path = "${var.source-path}"

  ssh_username = "root"
  ssh_private_key_file = "${var.root-certificate}"
  ssh_timeout  = "20m"

  shutdown_command = "poweroff"

  guest_additions_mode = "disable"

  # The final output file should be called Bhringa-VERSION.zip
  vm_name = "Bhringa-${var.vm-version}"

  switch_name = "Default Switch"

  headless = true
}

build {
  name = "bhringa-hyperv"

  sources = [
    "sources.hyperv-vmcx.bhringa-hyperv"
  ]

  provisioner "shell" {
    scripts = [
      "buildscripts/10-setup-dev-env.sh",
      "buildscripts/20-set-hostname.sh",
      "buildscripts/40-stamp-release.sh"
    ]

    # Ensure the VM_VERSION variable.
    environment_vars = [
      "VM_VERSION=${var.vm-version}"
    ]

  }

  provisioner "file" {
    sources = [
      "attachments/hyperv-filesystem/"
    ]

    destination = "/"
  }

  post-processor "compress" {
    # The final output file should be called Bhringa-VERSION.zip
    output = "output-{{ .BuildName }}/Bhringa-${var.vm-version}.zip"
    keep_input_artifact = true
  }
}

packer {
  required_version = ">= 1.9.2"
  required_plugins {
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = "~> 1"
    }
  }
}
