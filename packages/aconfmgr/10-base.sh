# === SYSTEM BASE ===
AddPackage base # Minimal package set to define a basic Arch Linux installation
AddPackage base-devel # Basic tools to build Arch Linux packages
AddPackage linux # The Linux kernel and modules
AddPackage linux-headers # Headers and scripts for building modules for the Linux kernel
AddPackage linux-firmware # Firmware files for Linux - Default set
AddPackage amd-ucode # Microcode update image for AMD CPUs (Framework 16)
AddPackage lvm2 # Logical Volume Manager 2 utilities (LUKS)
AddPackage sudo # Give certain users the ability to run some commands as root

# === GPU NVIDIA ===
AddPackage nvidia-open-dkms # NVIDIA open kernel modules (RTX 50 series Blackwell)
