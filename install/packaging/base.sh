# Install all base packages
mapfile -t packages < <(grep -v '^#' "$KARAMEL_INSTALL/karamel-base.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"
