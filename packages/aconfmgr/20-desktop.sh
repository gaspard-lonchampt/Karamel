# === COMPOSITEURS WAYLAND ===
AddPackage hyprland # a highly customizable dynamic tiling Wayland compositor
AddPackage niri # A scrollable-tiling Wayland compositor
AddPackage quickshell # Flexible toolkit for making desktop shells with QtQuick
AddPackage --foreign dms-shell-git # Desktop shell for wayland compositors built with Quickshell & GO

# === BOOT & GREETER ===
AddPackage plymouth # Graphical boot splash screen
AddPackage greetd # Generic greeter daemon
AddPackage --foreign greetd-dms-greeter-git # DankMaterialShell greeter for greetd

# === PORTAILS XDG ===
AddPackage xdg-desktop-portal-hyprland # xdg-desktop-portal backend for hyprland
AddPackage xdg-desktop-portal-gtk # A backend implementation for xdg-desktop-portal using GTK
AddPackage xdg-desktop-portal-gnome # Backend implementation for xdg-desktop-portal for the GNOME desktop environment

# === OUTILS WAYLAND ===
AddPackage grim # Screenshot utility for Wayland
AddPackage slurp # Select a region in a Wayland compositor
AddPackage satty # Modern screenshot annotation tool, inspired by Swappy and Flameshot
AddPackage wl-clipboard # Command-line copy/paste utilities for Wayland
AddPackage wl-clip-persist # Keep Wayland clipboard even after programs close
AddPackage cliphist # wayland clipboard manager
AddPackage swaybg # Wallpaper tool for Wayland compositors
AddPackage swayidle # Idle management daemon for Wayland
AddPackage hypridle # hyprland's idle daemon
AddPackage mako # Lightweight notification daemon for Wayland
AddPackage nwg-displays # Output management utility for sway and Hyprland Wayland compositors
AddPackage --foreign wdisplays # GUI display configurator for wlroots compositors
AddPackage brightnessctl # Lightweight brightness control tool
