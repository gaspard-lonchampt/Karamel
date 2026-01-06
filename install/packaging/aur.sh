# Install AUR packages with yay
mapfile -t packages < <(grep -v '^#' "$KARAMEL_INSTALL/karamel-aur.packages" | grep -v '^$')
yay -S --noconfirm --needed "${packages[@]}"
