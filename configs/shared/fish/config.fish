if status is-interactive
    # SSH keys management with keychain
    keychain --eval --quiet id_ed25519_github_2025 id_ed25519_mobilic_scalingo_2025 | source
end

# Set cursor theme for niri compositor
set -gx XCURSOR_THEME "Bibata-Modern-Ice"
set -gx XCURSOR_SIZE "24"

# Add scripts directory to PATH
fish_add_path $HOME/.config/scripts

# Helix editor alias
alias hx helix

# Claude Code alias
alias cc claude

# Display configuration alias
alias kdisplay wdisplays

# npm global packages
if not contains $HOME/.npm-global/bin $PATH
    set -gx PATH $HOME/.npm-global/bin $PATH
end

# aconfmgr reminder for pacman/yay
function pacman --wraps=pacman
    echo "╭───────────────────────────────────────────────────────╮"
    echo "│ 📦 aconfmgr - Add package to the right file:          │"
    echo "│   ~/.config/aconfmgr/XX-category.sh                   │"
    echo "│   AddPackage name  # description                      │"
    echo "│                                                       │"
    echo "│ Or: aconfmgr save → sort 99-unsorted.sh → clear it    │"
    echo "╰───────────────────────────────────────────────────────╯"
    command pacman $argv
end

function yay --wraps=yay
    echo "╭───────────────────────────────────────────────────────╮"
    echo "│ 📦 aconfmgr - Add package to the right file:          │"
    echo "│   ~/.config/aconfmgr/XX-category.sh                   │"
    echo "│   AddPackage name  # description                      │"
    echo "│                                                       │"
    echo "│ Or: aconfmgr save → sort 99-unsorted.sh → clear it    │"
    echo "╰───────────────────────────────────────────────────────╯"
    command yay $argv
end

