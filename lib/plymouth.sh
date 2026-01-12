#!/usr/bin/env bash
# Plymouth boot theme setup functions for Karamel installer
# Installs the Karamel Plymouth theme with tiger-stripe logo

# Source utils for logging
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Check if Plymouth is installed
check_plymouth() {
    if ! command_exists plymouth; then
        log_warn "Plymouth is not installed. Skipping boot theme setup."
        return 1
    fi
    return 0
}

# Install Karamel Plymouth theme
install_plymouth_theme() {
    local repo_dir="$1"
    local theme_source="$repo_dir/assets/plymouth"
    local theme_dest="/usr/share/plymouth/themes/karamel"

    log_info "Installing Karamel Plymouth theme..."

    # Check if source files exist
    if [ ! -d "$theme_source" ]; then
        log_error "Plymouth theme source not found: $theme_source"
        return 1
    fi

    # Create destination directory
    sudo mkdir -p "$theme_dest"

    # Copy theme files
    sudo cp "$theme_source/karamel.plymouth" "$theme_dest/"
    sudo cp "$theme_source/karamel.script" "$theme_dest/"
    sudo cp "$theme_source/logo.png" "$theme_dest/"
    sudo cp "$theme_source/progress_box.png" "$theme_dest/"
    sudo cp "$theme_source/progress_bar.png" "$theme_dest/"
    sudo cp "$theme_source/bullet.png" "$theme_dest/"
    sudo cp "$theme_source/entry.png" "$theme_dest/"
    sudo cp "$theme_source/lock.png" "$theme_dest/"

    log_success "Plymouth theme files copied to $theme_dest"
}

# Set Karamel as default Plymouth theme
set_default_theme() {
    log_info "Setting Karamel as default Plymouth theme..."

    # Check if plymouth-set-default-theme exists
    if command_exists plymouth-set-default-theme; then
        sudo plymouth-set-default-theme karamel
        log_success "Karamel set as default Plymouth theme"
    else
        log_warn "plymouth-set-default-theme not found. You may need to set the theme manually."
        return 1
    fi
}

# Regenerate initramfs to include Plymouth theme
regenerate_initramfs() {
    log_info "Regenerating initramfs..."

    if command_exists mkinitcpio; then
        sudo mkinitcpio -P
        log_success "initramfs regenerated with mkinitcpio"
    elif command_exists dracut; then
        sudo dracut --regenerate-all --force
        log_success "initramfs regenerated with dracut"
    else
        log_warn "Could not regenerate initramfs. Please run 'mkinitcpio -P' or 'dracut' manually."
        return 1
    fi
}

# Check if Plymouth is in mkinitcpio.conf HOOKS
check_mkinitcpio_hooks() {
    if [ -f /etc/mkinitcpio.conf ]; then
        if grep -q "plymouth" /etc/mkinitcpio.conf; then
            log_info "Plymouth is already in mkinitcpio.conf HOOKS"
            return 0
        else
            log_warn "Plymouth is not in mkinitcpio.conf HOOKS"
            log_info "You may need to add 'plymouth' to the HOOKS array in /etc/mkinitcpio.conf"
            log_info "Example: HOOKS=(base udev plymouth autodetect modconf ...)"
            return 1
        fi
    fi
    return 0
}

# Main Plymouth setup function
setup_plymouth() {
    local repo_dir="$1"

    log_step "Setting Up Karamel Plymouth Boot Theme"

    # Check if Plymouth is installed
    if ! check_plymouth; then
        return 1
    fi

    log_info "This step requires sudo privileges to install the boot theme"
    echo ""

    install_plymouth_theme "$repo_dir"
    set_default_theme
    check_mkinitcpio_hooks

    echo ""
    log_info "Regenerating initramfs is required for the theme to take effect."
    if prompt_yes_no "Regenerate initramfs now?" "y"; then
        regenerate_initramfs
    else
        log_warn "Skipping initramfs regeneration. Run 'sudo mkinitcpio -P' manually before reboot."
    fi

    echo ""
    log_success "Karamel Plymouth theme setup complete!"
    log_info "The boot splash will display the Karamel tiger-stripe logo"
}
