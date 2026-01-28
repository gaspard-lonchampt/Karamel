# === STEAM & PROTON ===
AddPackage steam # Valve's digital software delivery system
AddPackage --foreign protonup-qt # Install and manage Proton-GE and Luxtorpeda for Steam and Wine-GE for Lutris
AddPackage protontricks # A simple wrapper that does winetricks things for Proton enabled games (now native)

# === DRIVERS 32-BIT ===
AddPackage lib32-nvidia-utils # NVIDIA drivers utilities (32-bit)
AddPackage lib32-vulkan-icd-loader # Vulkan Installable Client Driver (ICD) Loader (32-bit)

# === OPTIMISATION PERFORMANCE ===
AddPackage gamemode # A daemon/lib combo that allows games to request a set of optimisations be temporarily applied
AddPackage lib32-gamemode # A daemon/lib combo that allows games to request a set of optimisations be temporarily applied (32-bit)
AddPackage gamescope # SteamOS session compositing window manager
AddPackage mangohud # A Vulkan overlay layer for monitoring FPS, temperatures, CPU/GPU load and more
AddPackage lib32-mangohud # A Vulkan overlay layer for monitoring FPS, temperatures, CPU/GPU load and more (32-bit)

# === OUTILS VULKAN ===
AddPackage vulkan-tools # Vulkan Utilities and Tools

# === XWAYLAND (requis pour Steam sur Niri) ===
AddPackage xwayland-satellite # XWayland outside your Wayland
