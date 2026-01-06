if [ "$(plymouth-set-default-theme)" != "karamel" ]; then
  sudo cp -r "$HOME/.local/share/karamel/default/plymouth" /usr/share/plymouth/themes/karamel/
  sudo plymouth-set-default-theme karamel
fi
