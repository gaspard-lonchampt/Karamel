# Karamel

A fork of [Omarchy](https://github.com/basecamp/omarchy) using **Niri** instead of Hyprland.

## Why Karamel?

Omarchy is an excellent Arch Linux configuration, but it's built around Hyprland. Karamel follows the same philosophy and uses the same tools, replacing the compositor with [Niri](https://github.com/YaLTeR/niri) — a scrollable-tiling Wayland compositor.

### Why Niri?

- **Scrollable tiling**: Windows are organized in columns that scroll horizontally, rather than a binary tree
- **Simplicity**: Less configuration needed, predictable behavior
- **Stability**: Fewer features = fewer bugs

## Differences from Omarchy

| Component | Omarchy | Karamel |
|-----------|---------|---------|
| Compositor | Hyprland | Niri |
| Lock screen | hyprlock | swaylock-effects |
| Idle manager | hypridle | swayidle |
| Wallpaper | swaybg | swww |
| XDG Portal | portal-hyprland | portal-gnome |
| Password manager | 1Password | Bitwarden |
| Browser | Chromium | Zen Browser |
| Shell | Bash | Fish |

### Additions

- Gaming: Steam, Proton, GameMode, MangoHud, NVIDIA drivers
- Communication: Discord, WhatsApp, Thunderbird
- Tools: tmux, mcfly, VLC

### Removals

- 37signals products (HEY, Basecamp, Fizzy)
- ChatGPT webapp

## Installation

On a fresh Arch Linux install (after `archinstall` with minimal profile):

```bash
curl -sL https://raw.githubusercontent.com/gaspard-lonchampt/Karamel/master/boot.sh | bash
```

## Credits

- [Omarchy](https://github.com/basecamp/omarchy) by Basecamp — the foundation of this project
- [Niri](https://github.com/YaLTeR/niri) by YaLTeR — the Wayland compositor

## License

MIT
