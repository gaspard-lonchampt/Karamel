# Set links for Nautilius action icons
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-previous-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-previous-symbolic.svg
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-next-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-next-symbolic.svg

# Setup theme links
mkdir -p ~/.config/karamel/themes
for f in ~/.local/share/karamel/themes/*; do ln -nfs "$f" ~/.config/karamel/themes/; done

# Set initial theme
mkdir -p ~/.config/karamel/current
ln -snf ~/.config/karamel/themes/tokyo-night ~/.config/karamel/current/theme
ln -snf ~/.config/karamel/current/theme/backgrounds/1-scenery-pink-lakeside-sunset-lake-landscape-scenic-panorama-7680x3215-144.png ~/.config/karamel/current/background

# Set specific app links for current theme
# ~/.config/karamel/current/theme/neovim.lua -> ~/.config/nvim/lua/plugins/theme.lua is handled via karamel-setup-nvim

mkdir -p ~/.config/btop/themes
ln -snf ~/.config/karamel/current/theme/btop.theme ~/.config/btop/themes/current.theme

mkdir -p ~/.config/mako
ln -snf ~/.config/karamel/current/theme/mako.ini ~/.config/mako/config

# Add managed policy directories for Chromium and Brave for theme changes
sudo mkdir -p /etc/chromium/policies/managed
sudo chmod a+rw /etc/chromium/policies/managed

sudo mkdir -p /etc/brave/policies/managed
sudo chmod a+rw /etc/brave/policies/managed
