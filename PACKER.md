# Packer Build Instructions

The images for this repository can be built using HashiCorp [Packer](https://www.packer.io/).

## Build Prerequisites

1. Oracle VirtualBox, version 6.0 or above. The `VBoxManage` tool must be on the path. OR Microsoft Hyper-V, with all management tools enabled.
2. HashiCorp Packer, version 1.9.2 or above.
3. The Rajware [Matsya](https://github.com/rajware/dockercourse-image) image, which is an ova file for VirtualBox or a zip file for Hyper-V, and the key pair file used to create it. See that repository for details.

## Build Instructions

1. Update the file `bhringa-vbox.pkr.hcl` with the path to the Matsya ova file and the key pair file, OR update `bhringa-hyperv.pkr.hcl` with the directory where the Matsya zip was expanded and the key pair file.
2. Run `packer build matsya-vbox.pkr.hcl` or `packer build matsya-hyperv.pkr.hcl`. 

## Makefile

The steps described above can also be performed via a supplied [Makefile](Makefile) and GNU make, for building a VirtualBox image only. `make vbox` can be used. The image version, ova file path and key file path can be updated in the Makefile. The Makefile is intended for UNIXlikes.

## Invoke-Build

An [Invoke-Build](https://github.com/nightroman/Invoke-Build) [script](invoke.build.ps1) is also available. `Invoke-Build keys` and `Invoke-Build vbox` can be used, instead of GNU make. The image version, ova file path OR expanded zip directory, and key file path can be updated in the script, `invoke-build.ps1`. The Invoke-Build script will work on Windows, and also UNIXlikes if PowerShell is installed and the Invoke-Build module is installed.
