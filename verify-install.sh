#!/usr/bin/env bash
# Karamel Post-Installation Verification Script
# Vérifie que tous les composants sont correctement installés

set -u

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Counters
PASS=0
FAIL=0
WARN=0

# Results arrays
declare -a FAILED_ITEMS=()
declare -a WARNING_ITEMS=()

print_header() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  🍬 Karamel - Vérification Post-Installation${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${BLUE}▶ $1${NC}"
    echo -e "${BLUE}$(printf '─%.0s' {1..60})${NC}"
}

check_pass() {
    echo -e "  ${GREEN}✓${NC} $1"
    ((PASS++))
}

check_fail() {
    echo -e "  ${RED}✗${NC} $1"
    ((FAIL++))
    FAILED_ITEMS+=("$1")
}

check_warn() {
    echo -e "  ${YELLOW}⚠${NC} $1"
    ((WARN++))
    WARNING_ITEMS+=("$1")
}

# ============================================================================
# Package Checks
# ============================================================================

check_packages() {
    print_section "Paquets Installés"

    # Critical packages
    local critical_packages=(
        "hyprland:Compositeur Hyprland"
        "kitty:Terminal Kitty"
        "fish:Shell Fish"
        "greetd:Display Manager"
    )

    # Important packages
    local important_packages=(
        "niri:Compositeur Niri"
        "hypridle:Gestion veille Hyprland"
        "wl-clipboard:Clipboard Wayland"
        "brightnessctl:Contrôle luminosité"
        "pavucontrol:Contrôle audio"
        "nemo:Gestionnaire fichiers"
        "fastfetch:Info système"
    )

    # Theme packages
    local theme_packages=(
        "catppuccin-gtk-theme-mocha:Thème GTK Catppuccin"
        "yaru-icon-theme:Icônes Yaru"
        "bibata-cursor-theme-bin:Curseur Bibata"
        "kvantum:Moteur thème Qt"
        "qt5ct:Config Qt5"
        "qt6ct:Config Qt6"
    )

    # DMS packages (AUR)
    local dms_packages=(
        "dms-shell-git:DankMaterialShell"
        "quickshell:Framework shell"
        "greetd-dms-greeter-git:DMS Greeter"
    )

    echo "  Paquets critiques:"
    for entry in "${critical_packages[@]}"; do
        local pkg="${entry%%:*}"
        local desc="${entry#*:}"
        if pacman -Q "$pkg" &>/dev/null; then
            local version=$(pacman -Q "$pkg" 2>/dev/null | awk '{print $2}')
            check_pass "$desc ($pkg $version)"
        else
            check_fail "$desc ($pkg) - NON INSTALLÉ"
        fi
    done

    echo ""
    echo "  Paquets importants:"
    for entry in "${important_packages[@]}"; do
        local pkg="${entry%%:*}"
        local desc="${entry#*:}"
        if pacman -Q "$pkg" &>/dev/null; then
            check_pass "$desc ($pkg)"
        else
            check_warn "$desc ($pkg) - non installé"
        fi
    done

    echo ""
    echo "  Paquets thèmes:"
    for entry in "${theme_packages[@]}"; do
        local pkg="${entry%%:*}"
        local desc="${entry#*:}"
        if pacman -Q "$pkg" &>/dev/null; then
            check_pass "$desc ($pkg)"
        else
            check_warn "$desc ($pkg) - non installé"
        fi
    done

    echo ""
    echo "  Paquets DMS (AUR):"
    for entry in "${dms_packages[@]}"; do
        local pkg="${entry%%:*}"
        local desc="${entry#*:}"
        if pacman -Q "$pkg" &>/dev/null; then
            check_pass "$desc ($pkg)"
        else
            check_fail "$desc ($pkg) - NON INSTALLÉ"
        fi
    done
}

# ============================================================================
# Symlink Checks
# ============================================================================

check_symlinks() {
    print_section "Symlinks Configuration"

    local symlinks=(
        "$HOME/.config/fish:Fish shell"
        "$HOME/.config/kitty:Terminal Kitty"
        "$HOME/.config/gtk-3.0:GTK 3.0"
        "$HOME/.config/gtk-4.0:GTK 4.0"
        "$HOME/.config/hypr:Hyprland"
        "$HOME/.config/niri:Niri"
    )

    for entry in "${symlinks[@]}"; do
        local path="${entry%%:*}"
        local desc="${entry#*:}"

        if [ -L "$path" ]; then
            local target=$(readlink "$path")
            if [ -d "$target" ] || [ -f "$target" ]; then
                check_pass "$desc → $target"
            else
                check_fail "$desc → $target (cible inexistante)"
            fi
        elif [ -d "$path" ]; then
            check_warn "$desc existe mais n'est pas un symlink"
        else
            check_fail "$desc ($path) - MANQUANT"
        fi
    done

    # Check DMS config (may be copied, not symlinked)
    if [ -d "$HOME/.config/DankMaterialShell" ]; then
        if [ -f "$HOME/.config/DankMaterialShell/settings.json" ]; then
            check_pass "DankMaterialShell config présent"
        else
            check_warn "DankMaterialShell config incomplet"
        fi
    else
        check_fail "DankMaterialShell config - MANQUANT"
    fi

    # Check assets symlink
    if [ -L "$HOME/.config/karamel/assets" ]; then
        check_pass "Assets Karamel symlinked"
    elif [ -d "$HOME/.config/karamel/assets" ]; then
        check_pass "Assets Karamel présents"
    else
        check_warn "Assets Karamel non trouvés"
    fi
}

# ============================================================================
# Service Checks
# ============================================================================

check_services() {
    print_section "Services Système"

    # greetd
    if systemctl is-enabled greetd.service &>/dev/null; then
        check_pass "greetd.service activé"
    else
        check_fail "greetd.service NON activé"
    fi

    # Check for conflicting DMs
    local conflicting_dms=("gdm" "sddm" "lightdm" "lxdm")
    for dm in "${conflicting_dms[@]}"; do
        if systemctl is-enabled "${dm}.service" &>/dev/null; then
            check_warn "${dm}.service est activé (conflit potentiel)"
        fi
    done

    # greetd config
    if [ -f "/etc/greetd/config.toml" ]; then
        if grep -q "dms-greeter" /etc/greetd/config.toml; then
            check_pass "greetd configuré pour dms-greeter"
        else
            check_warn "greetd config existe mais pas pour dms-greeter"
        fi
    else
        check_fail "greetd config (/etc/greetd/config.toml) - MANQUANT"
    fi
}

# ============================================================================
# Session Files Checks
# ============================================================================

check_sessions() {
    print_section "Fichiers de Session"

    local sessions_dir="/usr/share/wayland-sessions"

    if [ -f "$sessions_dir/hyprland-dms.desktop" ]; then
        check_pass "Session Hyprland (DMS) disponible"
    elif [ -f "$sessions_dir/hyprland.desktop" ]; then
        check_warn "Session Hyprland standard (pas DMS)"
    else
        check_warn "Pas de fichier session Hyprland"
    fi

    if [ -f "$sessions_dir/niri-dms.desktop" ]; then
        check_pass "Session Niri (DMS) disponible"
    elif [ -f "$sessions_dir/niri.desktop" ]; then
        check_warn "Session Niri standard (pas DMS)"
    else
        check_warn "Pas de fichier session Niri"
    fi
}

# ============================================================================
# Theme Checks
# ============================================================================

check_themes() {
    print_section "Thèmes et Apparence"

    # GTK theme
    local gtk_theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")
    if [[ "$gtk_theme" == *"catppuccin"* ]]; then
        check_pass "Thème GTK: $gtk_theme"
    elif [ -n "$gtk_theme" ]; then
        check_warn "Thème GTK: $gtk_theme (pas Catppuccin)"
    else
        check_warn "Impossible de lire le thème GTK"
    fi

    # Icon theme
    local icon_theme=$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | tr -d "'")
    if [[ "$icon_theme" == *"Yaru"* ]]; then
        check_pass "Icônes: $icon_theme"
    elif [ -n "$icon_theme" ]; then
        check_warn "Icônes: $icon_theme (pas Yaru)"
    else
        check_warn "Impossible de lire le thème d'icônes"
    fi

    # Cursor theme
    local cursor_theme=$(gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null | tr -d "'")
    if [[ "$cursor_theme" == *"Bibata"* ]]; then
        check_pass "Curseur: $cursor_theme"
    elif [ -n "$cursor_theme" ]; then
        check_warn "Curseur: $cursor_theme (pas Bibata)"
    else
        check_warn "Impossible de lire le thème de curseur"
    fi

    # Dark mode
    local color_scheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null | tr -d "'")
    if [[ "$color_scheme" == "prefer-dark" ]]; then
        check_pass "Mode sombre activé"
    else
        check_warn "Mode sombre: $color_scheme"
    fi
}

# ============================================================================
# Shell Checks
# ============================================================================

check_shell() {
    print_section "Configuration Shell"

    # Default shell
    local default_shell=$(getent passwd "$USER" | cut -d: -f7)
    if [[ "$default_shell" == *"fish"* ]]; then
        check_pass "Shell par défaut: fish"
    else
        check_warn "Shell par défaut: $default_shell (pas fish)"
    fi

    # Fish config
    if [ -f "$HOME/.config/fish/config.fish" ]; then
        check_pass "config.fish présent"
    else
        check_fail "config.fish - MANQUANT"
    fi

    # Environment variables
    if [ -n "${XCURSOR_THEME:-}" ]; then
        check_pass "XCURSOR_THEME défini: $XCURSOR_THEME"
    else
        check_warn "XCURSOR_THEME non défini dans l'environnement actuel"
    fi
}

# ============================================================================
# Karamel Repository Checks
# ============================================================================

check_karamel_repo() {
    print_section "Dépôt Karamel"

    local karamel_dir="$HOME/Karamel"

    if [ -d "$karamel_dir" ]; then
        check_pass "Dossier Karamel présent"
    else
        check_fail "Dossier Karamel - MANQUANT"
        return
    fi

    # Check key directories
    local dirs=("configs" "lib" "packages" "assets")
    for dir in "${dirs[@]}"; do
        if [ -d "$karamel_dir/$dir" ]; then
            check_pass "Dossier $dir présent"
        else
            check_fail "Dossier $dir - MANQUANT"
        fi
    done

    # Check install script
    if [ -x "$karamel_dir/install.sh" ]; then
        check_pass "install.sh exécutable"
    elif [ -f "$karamel_dir/install.sh" ]; then
        check_warn "install.sh présent mais non exécutable"
    else
        check_fail "install.sh - MANQUANT"
    fi

    # Check git status
    if [ -d "$karamel_dir/.git" ]; then
        check_pass "Dépôt git initialisé"
        cd "$karamel_dir"
        if git diff --quiet 2>/dev/null; then
            check_pass "Pas de modifications non commitées"
        else
            check_warn "Modifications locales non commitées"
        fi
        cd - >/dev/null
    else
        check_warn "Pas un dépôt git"
    fi
}

# ============================================================================
# Runtime Checks
# ============================================================================

check_runtime() {
    print_section "État Runtime"

    # Check if running in Wayland
    if [ -n "${WAYLAND_DISPLAY:-}" ]; then
        check_pass "Session Wayland active: $WAYLAND_DISPLAY"
    else
        check_warn "Pas de session Wayland détectée"
    fi

    # Check compositor
    if pgrep -x "Hyprland" >/dev/null; then
        check_pass "Hyprland en cours d'exécution"
    elif pgrep -x "niri" >/dev/null; then
        check_pass "Niri en cours d'exécution"
    else
        check_warn "Aucun compositeur Karamel détecté"
    fi

    # Check DMS
    if pgrep -f "dms" >/dev/null; then
        check_pass "DankMaterialShell en cours d'exécution"
    else
        check_warn "DankMaterialShell non détecté"
    fi
}

# ============================================================================
# Summary
# ============================================================================

print_summary() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  Résumé${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    echo -e "  ${GREEN}✓ Réussis:${NC}     $PASS"
    echo -e "  ${YELLOW}⚠ Warnings:${NC}    $WARN"
    echo -e "  ${RED}✗ Échecs:${NC}      $FAIL"
    echo ""

    if [ $FAIL -eq 0 ]; then
        echo -e "  ${GREEN}${BOLD}🎉 Installation Karamel vérifiée avec succès!${NC}"
    else
        echo -e "  ${RED}${BOLD}⚠ Problèmes détectés nécessitant attention${NC}"
        echo ""
        echo -e "  ${RED}Éléments en échec:${NC}"
        for item in "${FAILED_ITEMS[@]}"; do
            echo -e "    ${RED}•${NC} $item"
        done
    fi

    if [ $WARN -gt 0 ]; then
        echo ""
        echo -e "  ${YELLOW}Avertissements:${NC}"
        for item in "${WARNING_ITEMS[@]}"; do
            echo -e "    ${YELLOW}•${NC} $item"
        done
    fi

    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [ $FAIL -gt 0 ]; then
        echo ""
        echo -e "  ${BOLD}Actions recommandées:${NC}"
        echo "    1. Relancer le script d'installation: ~/Karamel/install.sh"
        echo "    2. Installer manuellement les paquets manquants"
        echo "    3. Consulter la documentation: ~/docs/install-analysis.md"
        echo ""
    fi
}

# ============================================================================
# Main
# ============================================================================

main() {
    print_header

    check_packages
    check_symlinks
    check_services
    check_sessions
    check_themes
    check_shell
    check_karamel_repo
    check_runtime

    print_summary

    # Exit with appropriate code
    if [ $FAIL -gt 0 ]; then
        exit 1
    else
        exit 0
    fi
}

main "$@"
