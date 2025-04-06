# ebpfcourse-image

VM image for the Rajware eBPF course

![GitHub release (latest by date)](https://img.shields.io/github/v/release/rajware/ebpfcourse-image?include_prereleases)

This repository contains build instructions and Packer templates for building VM images for the eBPF course conducted by Rajware. Images can be built for VirtualBox and Hyper-V.

Each image contains a self-contained Alpine Linux installation with XFCE, the open-source Docker Engine, and development tools including the llvm/clang compiler suite, libbpf and associated tools, and the Geany editor.

The VirtualBox image includes a display manager (lightdm), and is intended to be used from the VirtualBox UI directly. It offers a full GUI, with host clipboard integration. It can also be reached from the host via SSH, using hostname `localhost` and port 50022.

The Hyper-V image does not include a display manager. It is intended to be used via an RDP connection (Windows Remote Desktop for example). It also offers, via the RDP client software, a full GUI with host clipboard integration. It can also be reached from the host via SSH, using its IP address and port 22.

This image is built on top of the Rajware [Matsya](https://github.com/rajware/dockercourse-image) image.

## Building Images

Images can be built by running the Packer script as detailed in [PACKER.md](PACKER.md).

## Keys

If the Packer script is used, a key pair has to be supplied as described in [PACKER.md](PACKER.md). Since this image is built from the Rajware [Matsya](https://github.com/rajware/dockercourse-image) image, building this will require the key pair created during the creation of that image.

<img src="attachments/icon/bhringa.png" width="64" alt="Bhringa Icon" title="Bhringa Icon" />
