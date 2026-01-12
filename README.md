# Karamel-Config

**Karamel Desktop** for Hyprland & Niri with DankMaterialShell

A complete, ready-to-use desktop environment configuration for Arch Linux featuring modern Wayland compositors with Catppuccin aesthetics and Karamel branding.

> Fork personnalisé de [BD-Configs](https://gitlab.com/theblackdon/karamel) par TheBlackDon

## Features

- **Dual Compositor Support**: Choose between Hyprland (dynamic tiling) or Niri (scrollable tiling), or install both
- **DankMaterialShell (DMS)**: Beautiful Material Design shell with bar, notifications, launcher, and lock screen
- **Catppuccin Mocha Theme**: Consistent theming across all applications (GTK, Qt, terminal, shell)
- **Karamel Branding**: Custom pixel art cat logo and ASCII art for fastfetch
- **Yaru-sage Icons**: Fresh green icon theme for a natural look
- **DMS-Greeter**: Elegant display manager for seamless session switching
- **Karamel Plymouth Theme**: Tiger-stripe logo boot splash
- **Walker Keybindings Menu**: Search all keybindings with `Super + :`
- **Curated Applications**: kitty terminal, fish shell, nemo file manager, and optional apps
- **Symlinked Configs**: Easy to update - edit files in the repo and changes apply immediately
- **Optional dcli Integration**: Declarative package management for tracking your system configuration in YAML and git

## Screenshots

![Karamel Desktop](assets/screenshots/desktop-overview.png)
*Karamel running with Niri, DankMaterialShell, and Catppuccin Mocha theme*

## Requirements

- **OS**: Arch Linux or Arch-based distribution (CachyOS, EndeavourOS, etc.)
- **AUR Helper**: paru or yay
- **Internet Connection**: Required for package installation

## Installation

### Quick Install

```bash
git clone <your-repo-url>
cd karamel-config
./install.sh
```

The installer will guide you through:
1. System compatibility checks
2. Compositor selection (Hyprland, Niri, or both)
3. Optional application selection
4. dcli integration (optional)
5. Plymouth boot theme (optional)
6. Package installation
7. Configuration deployment
8. Theme application
9. Display manager setup
10. Plymouth theme installation (if selected)

### What Gets Installed

**Core Packages:**
- Build tools (git, cmake, meson, gcc, base-devel)
- jq and dialog for the installer

**Compositor Packages:**
- Hyprland: hyprland, hypridle, xdg-desktop-portals, screenshot tools, pyprland
- Niri: niri, waybar, mako, fuzzel, swayidle, screenshot tools

**Theme Packages:**
- Catppuccin GTK theme (Mocha variant)
- Yaru-sage icon theme (green)
- Bibata Modern Ice cursor theme
- Qt5/Qt6 Wayland support and theming
- Kvantum theme engine

**DMS & Display Manager:**
- DankMaterialShell (dms-shell-git)
- Quickshell (DMS dependency)
- greetd + greetd-dms-greeter-git

**Required Applications:**
- kitty (terminal)
- fish (shell)
- nemo (file manager)
- fastfetch (system info with Karamel cat ASCII art)

**Optional Applications:**
- Zen Browser (privacy-focused browser)
- Zed (modern code editor)
- Helix (modal text editor)

## Post-Installation

### First Login

1. **Reboot your system**
2. **At the DMS-greeter login screen:**
   - Select your preferred session (Hyprland or Niri)
   - Log in with your credentials
3. **Enjoy your Karamel desktop!**

### Customizing Colors (Recommended)

After first boot, customize your accent color via DMS:
1. Right-click on the bar → **Settings**
2. Go to **Theme** section
3. Choose a wallpaper with warm tones (peach/orange recommended with Yaru-sage icons)
4. Matugen will automatically generate harmonious colors

**Recommended accent**: Catppuccin **Peach** (#fab387) - complements Yaru-sage icons beautifully

### Key Bindings

#### Universal (Both Compositors)
- `Super + Space` - Application launcher (with Karamel cat logo)
- `Super + T` or `Super + Return` - Terminal (kitty)
- `Super + Ctrl + Return` - Floating Terminal (kitty)
- `Super + Q` - Close window
- `Super + F` - File manager (nemo)
- `Super + B` - Browser (if installed)
- `Super + :` - Keybindings menu (Walker)
- `Super + Shift + R` - Reload compositor config
- `Super + Alt + L` - Lock screen
- `Super + Ctrl + Up or Down` - Move relative workspaces

#### Media Keys
- `XF86AudioRaiseVolume` - Volume up
- `XF86AudioLowerVolume` - Volume down
- `XF86AudioMute` - Toggle mute
- `XF86MonBrightnessUp` - Brightness up
- `XF86MonBrightnessDown` - Brightness down


## Walker Keybindings Menu

Press `Super + :` (colon) to open a searchable menu of all keybindings for your current compositor. The menu is styled with Catppuccin Mocha colors and shows keybindings in "key → action" format.

The menu dynamically parses your compositor's config files:
- Hyprland: `configs/hyprland/hypr/keybinds-*.conf`
- Niri: `configs/niri/niri/binds.kdl`

## Plymouth Boot Theme

Karamel includes a custom Plymouth boot splash theme featuring the "KARAMEL" logo with tiger-stripe colors inspired by the Karamel cat mascot.

### Colors
- Orange clair/beige: `#e8c8a0`
- Orange: `#d4a574`
- Orange foncé: `#c87830`
- Marron: `#8b5a2b`
- Background: Catppuccin Mocha base `#1e1e2e`

### Manual Installation
If you didn't enable Plymouth during installation:
```bash
# Copy theme to system
sudo cp -r ~/Karamel/assets/plymouth /usr/share/plymouth/themes/karamel

# Set as default theme
sudo plymouth-set-default-theme karamel

# Regenerate initramfs
sudo mkinitcpio -P
```

### Prerequisites
Ensure Plymouth is installed and configured in mkinitcpio:
```bash
# Install Plymouth
sudo pacman -S plymouth

# Add 'plymouth' to HOOKS in /etc/mkinitcpio.conf
# Example: HOOKS=(base udev plymouth autodetect modconf ...)
```

## dcli Integration (Optional)

Karamel-Config supports optional integration with **dcli** - a declarative package management tool for Arch Linux inspired by NixOS.

### What is dcli?

dcli allows you to:
- Manage all your packages in YAML configuration files
- Track your entire system configuration in git
- Sync your setup across multiple machines
- Organize packages into reusable modules
- Declaratively manage systemd services

### What happens when you enable dcli?

If you choose to install dcli during setup, the installer will:
1. Install `dcli-arch-git` from AUR
2. Create a dcli configuration structure at `~/.config/arch-config`
3. Generate modules for all Karamel packages:
   - `base` - Core dependencies
   - `themes` - Catppuccin Mocha + Yaru-sage theme packages
   - `dms` - DankMaterialShell packages
   - `apps` - Terminal, file manager, shell
   - `hyprland` - Hyprland compositor (if selected)
   - `niri` - Niri compositor (if selected)
4. Create a host configuration file with all installed packages declared

### Using dcli after installation

```bash
# View your current configuration
dcli status

# Sync packages (install missing, optionally remove extras)
dcli sync

# List all modules
dcli module list

# Enable/disable modules
dcli module enable gaming
dcli module disable development

# Search and install packages
dcli search
dcli install firefox

# Set up git tracking (recommended for multi-machine setups)
dcli repo init

# Edit configurations
dcli edit
```

### Multi-machine setup with dcli

```bash
# On your first machine
dcli repo init              # Initialize git repository
dcli repo push              # Push to your git remote

# On additional machines
dcli repo clone             # Clone your configuration
dcli sync                   # Install all packages from config
```

For more information, visit the [dcli repository](https://gitlab.com/theblackdon/dcli-arch).

## Customization

All configuration files are symlinked from the repository, making customization easy:

```bash
cd karamel-config

# Edit compositor configs
nano configs/hyprland/hypr/hyprland.conf
nano configs/niri/niri/config.kdl

# Edit terminal config
nano configs/shared/kitty/kitty.conf

# Edit shell config
nano configs/shared/fish/config.fish

# Edit DMS settings
nano configs/shared/DankMaterialShell/settings.json

# Edit fastfetch (Karamel cat ASCII)
nano configs/shared/fastfetch/config.jsonc
```

Changes take effect immediately (or after reloading the compositor with `Super+Shift+R`).

### Changing Wallpapers

Replace the wallpaper at:
```bash
assets/wallpapers/wallpaper.png
```

Or edit the compositor config to point to your own wallpaper.

### Karamel Assets

Custom branding assets are located in `assets/`:
- `karamel-cat.txt` - ASCII art cat for fastfetch
- `karamel-logo.png` - Pixel art cat for DMS launcher

## Troubleshooting

### DMS-greeter doesn't start
```bash
# Check greetd status
sudo systemctl status greetd

# Check greetd config
cat /etc/greetd/config.toml

# Restart greetd
sudo systemctl restart greetd
```

### Themes not applying
```bash
# Reapply themes manually
gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-mauve-standard+default'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-sage'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
```

### DMS shell not starting
```bash
# Check if DMS is running
pgrep -a dms

# Start DMS manually
dms run
```

### Compositor won't start
```bash
# For Hyprland
Hyprland

# For Niri
niri-session

# Check logs
journalctl --user -xe
```

### Fastfetch not showing cat
```bash
# Test fastfetch
fastfetch

# Check if ASCII file exists
cat ~/.config/karamel/assets/karamel-cat.txt
```

## Uninstallation

To remove karamel-config and restore your system:

```bash
# Stop and disable greetd
sudo systemctl disable --now greetd

# Restore original configs (if you made a backup)
rm -rf ~/.config
mv ~/.config.backup-YYYYMMDD_HHMMSS ~/.config

# Remove symlinks
unlink ~/.config/hypr
unlink ~/.config/niri
unlink ~/.config/DankMaterialShell
# ... etc

# Optionally remove packages
sudo pacman -R hyprland niri dms-shell-git greetd-dms-greeter-git
```

## Directory Structure

```
karamel-config/
├── install.sh              # Main installer script
├── verify-install.sh       # Post-installation verification
├── README.md               # This file
├── lib/                    # Installer library functions
│   ├── utils.sh           # Utility functions
│   ├── checks.sh          # System checks
│   ├── packages.sh        # Package installation
│   ├── dotfiles.sh        # Config deployment
│   ├── themes.sh          # Theme application
│   ├── greeter.sh         # Display manager setup
│   ├── dcli.sh            # dcli integration
│   └── plymouth.sh        # Plymouth boot theme setup
├── configs/               # Configuration files
│   ├── shared/            # Shared between compositors
│   │   ├── fish/          # Fish shell config
│   │   ├── kitty/         # Kitty terminal config
│   │   ├── fastfetch/     # Fastfetch with Karamel cat
│   │   ├── walker/        # Walker launcher config
│   │   └── DankMaterialShell/  # DMS settings
│   ├── hyprland/          # Hyprland-specific
│   │   └── hypr/          # Hyprland config files
│   └── niri/              # Niri-specific
│       └── niri/          # Niri config files
├── scripts/               # Helper scripts
│   └── keybinds.sh        # Walker keybindings menu
├── packages/              # Package lists
└── assets/                # Wallpapers, Karamel branding
    ├── karamel-cat.txt    # ASCII art for fastfetch
    ├── karamel-logo.png   # Pixel art cat for launcher
    ├── plymouth/          # Plymouth boot theme
    │   ├── karamel.plymouth
    │   ├── karamel.script
    │   ├── logo.png       # Tiger-stripe KARAMEL logo
    │   └── *.png          # Progress bar and dialog assets
    └── wallpapers/        # Desktop wallpapers
```

## Credits

- **[BD-Configs](https://gitlab.com/theblackdon/karamel)** - Original dotfiles by TheBlackDon
- **[Karamel](https://github.com/...)** - Pixel art assets and branding
- **[DankMaterialShell (DMS)](https://github.com/dburian/DankMaterialShell)** - Beautiful Material Design shell for Wayland
- **[Hyprland](https://hyprland.org/)** - Dynamic tiling Wayland compositor
- **[Niri](https://github.com/YaLTeR/niri)** - Scrollable-tiling Wayland compositor
- **[Catppuccin](https://github.com/catppuccin/catppuccin)** - Soothing pastel theme
- **[Yaru](https://github.com/ubuntu/yaru)** - Icon theme
- **[greetd](https://git.sr.ht/~kennylevinsen/greetd)** - Minimal display manager

## License

MIT License - Feel free to use and modify as you wish!

---

**Karamel Desktop** - A cozy, personalized Arch Linux experience 🐱
