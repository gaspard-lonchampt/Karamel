#!/usr/bin/env bash
# Package installation functions for Karamel installer
# Supports aconfmgr .sh format (AddPackage lines)

# Source utils for logging
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Parse aconfmgr .sh file and extract package names
# Format: AddPackage [--foreign] package_name # comment
parse_aconfmgr_packages() {
    local package_file="$1"
    local packages=()

    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        # Match AddPackage lines (with or without --foreign)
        if [[ "$line" =~ ^[[:space:]]*AddPackage[[:space:]]+(--foreign[[:space:]]+)?([^[:space:]#]+) ]]; then
            local pkg="${BASH_REMATCH[2]}"
            packages+=("$pkg")
        fi
    done < "$package_file"

    echo "${packages[@]}"
}

# Install packages from an aconfmgr .sh file
install_aconfmgr_list() {
    local package_file="$1"
    local description="$2"

    if [ ! -f "$package_file" ]; then
        log_error "Package list file not found: $package_file"
        return 1
    fi

    # Check if AUR_HELPER is set
    if [ -z "${AUR_HELPER:-}" ]; then
        log_error "AUR_HELPER variable is not set. Please ensure system checks have run."
        return 1
    fi

    log_info "Installing $description..."

    # Parse packages from aconfmgr format
    local packages_str
    packages_str=$(parse_aconfmgr_packages "$package_file")

    if [ -z "$packages_str" ]; then
        log_warn "No packages found in $package_file"
        return 0
    fi

    # Convert to array
    read -ra packages <<< "$packages_str"

    local official_packages=()
    local aur_packages=()

    # Separate official and AUR packages
    for pkg in "${packages[@]}"; do
        if pacman -Si "$pkg" >/dev/null 2>&1; then
            official_packages+=("$pkg")
        else
            aur_packages+=("$pkg")
        fi
    done

    # Install official packages with pacman
    if [ ${#official_packages[@]} -gt 0 ]; then
        log_info "Installing official packages: ${official_packages[*]}"
        sudo pacman -S --needed --noconfirm "${official_packages[@]}"
        if [ $? -ne 0 ]; then
            log_error "Failed to install some official packages"
            return 1
        fi
    fi

    # Install AUR packages with AUR helper
    if [ ${#aur_packages[@]} -gt 0 ]; then
        log_info "Installing AUR packages: ${aur_packages[*]}"
        local failed_packages=()
        # Install AUR packages one by one to handle conflicts better
        for pkg in "${aur_packages[@]}"; do
            log_info "Installing AUR package: $pkg"
            yes | "${AUR_HELPER}" -S --needed "${pkg}"
            if [ $? -ne 0 ]; then
                log_warn "Failed to install $pkg"
                failed_packages+=("$pkg")
            else
                log_success "$pkg installed"
            fi
        done

        if [ ${#failed_packages[@]} -gt 0 ]; then
            echo ""
            log_error "Some AUR packages failed to install:"
            for pkg in "${failed_packages[@]}"; do
                echo "  ✗ $pkg"
            done
            echo ""
            log_warn "Installation continuing, but some features may not work"
            echo ""
        fi
    fi

    log_success "$description installed successfully"
    return 0
}

# Install core dependencies (base system)
install_core_packages() {
    local repo_dir="$1"
    log_step "Installing Core Dependencies"
    install_aconfmgr_list "$repo_dir/packages/aconfmgr/10-base.sh" "Base System"
    install_aconfmgr_list "$repo_dir/packages/aconfmgr/60-dev.sh" "Development Tools"
}

# Install compositor packages (Wayland desktop)
install_compositor_packages() {
    local repo_dir="$1"
    local install_hyprland="$2"
    local install_niri="$3"

    log_step "Installing Wayland Desktop Components"

    # Install common desktop packages (both compositors need these)
    install_aconfmgr_list "$repo_dir/packages/aconfmgr/20-desktop.sh" "Wayland Desktop"
    install_aconfmgr_list "$repo_dir/packages/aconfmgr/30-audio-bluetooth.sh" "Audio & Bluetooth"
    install_aconfmgr_list "$repo_dir/packages/aconfmgr/35-power.sh" "Power Management"
}

# Install theme packages
install_theme_packages() {
    local repo_dir="$1"
    log_step "Installing Theme Packages"
    install_aconfmgr_list "$repo_dir/packages/aconfmgr/50-themes.sh" "Themes & Fonts"
}

# Install DMS packages (included in 20-desktop.sh)
install_dms_packages() {
    local repo_dir="$1"
    log_step "Installing DankMaterialShell"
    # DMS packages are already in 20-desktop.sh
    log_success "DMS packages included in desktop installation"
}

# Install required apps
install_required_apps() {
    local repo_dir="$1"
    log_step "Installing Required Applications"
    install_aconfmgr_list "$repo_dir/packages/aconfmgr/40-terminal-shell.sh" "Terminal & Shell"
    install_aconfmgr_list "$repo_dir/packages/aconfmgr/70-apps.sh" "Applications"
}

# Install optional apps
install_optional_apps() {
    local repo_dir="$1"
    shift
    local apps=("$@")

    if [ ${#apps[@]} -eq 0 ]; then
        log_info "No optional applications selected"
        return 0
    fi

    log_step "Installing Optional Applications"

    for app in "${apps[@]}"; do
        log_info "Installing $app..."
        $AUR_HELPER -S --needed --noconfirm "$app"
        if [ $? -eq 0 ]; then
            log_success "$app installed"
        else
            log_warn "Failed to install $app, continuing..."
        fi
    done
}
