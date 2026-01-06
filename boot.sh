#!/bin/bash

# Set install mode to online since boot.sh is used for curl installations
export KARAMEL_ONLINE_INSTALL=true

ansi_art='
\e[38;5;208m ██╗  ██╗ █████╗ ██████╗  █████╗ ███╗   ███╗███████╗██╗
\e[38;5;208m ██║ ██╔╝██╔══██╗██╔══██╗██╔══██╗████╗ ████║██╔════╝██║
\e[38;5;172m █████╔╝ ███████║██████╔╝███████║██╔████╔██║█████╗  ██║
\e[38;5;172m ██╔═██╗ ██╔══██║██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║
\e[38;5;130m ██║  ██╗██║  ██║██║  ██║██║  ██║██║ ╚═╝ ██║███████╗███████╗
\e[38;5;130m ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝\e[0m'

clear
echo -e "\n$ansi_art\n"

sudo pacman -Syu --noconfirm --needed git

# Use custom repo if specified, otherwise default to gaspard-lonchampt/Karamel
KARAMEL_REPO="${KARAMEL_REPO:-gaspard-lonchampt/Karamel}"

echo -e "\nCloning Karamel from: https://github.com/${KARAMEL_REPO}.git"
rm -rf ~/.local/share/karamel/
git clone "https://github.com/${KARAMEL_REPO}.git" ~/.local/share/karamel >/dev/null

# Use custom branch if instructed, otherwise default to master
KARAMEL_REF="${KARAMEL_REF:-master}"
if [[ $KARAMEL_REF != "master" ]]; then
  echo -e "\e[32mUsing branch: $KARAMEL_REF\e[0m"
  cd ~/.local/share/karamel
  git fetch origin "${KARAMEL_REF}" && git checkout "${KARAMEL_REF}"
  cd -
fi

echo -e "\nInstallation starting..."
source ~/.local/share/karamel/install.sh
