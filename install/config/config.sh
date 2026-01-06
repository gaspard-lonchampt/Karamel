# Copy over Karamel configs
mkdir -p ~/.config
cp -R ~/.local/share/karamel/config/* ~/.config/

# Use default bashrc from Karamel
cp ~/.local/share/karamel/default/bashrc ~/.bashrc
