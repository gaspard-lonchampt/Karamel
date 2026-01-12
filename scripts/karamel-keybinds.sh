#!/bin/bash
# Karamel Keybinds - Parse compositor configs and generate Walker menu
# Hyprland: uses hyprctl binds -j (native JSON)
# Niri: parses binds.kdl (manual parsing)

OUTPUT_DIR="$HOME/.config/karamel"
OUTPUT_JSON="$OUTPUT_DIR/keybinds.json"
OUTPUT_TXT="$OUTPUT_DIR/keybinds.txt"
NIRI_CONFIG="$HOME/.config/niri/binds.kdl"

mkdir -p "$OUTPUT_DIR"

detect_compositor() {
    if pgrep -x niri > /dev/null; then
        echo "niri"
    elif pgrep -x Hyprland > /dev/null; then
        echo "hyprland"
    else
        echo "unknown"
    fi
}

# Convert hyprland modifier mask to readable format
decode_modmask() {
    local mask=$1
    local mods=""

    # SUPER=64, ALT=8, CTRL=4, SHIFT=1
    if (( mask >= 64 )); then
        mods+="Super + "
        mask=$((mask - 64))
    fi
    if (( mask >= 8 )); then
        mods+="Alt + "
        mask=$((mask - 8))
    fi
    if (( mask >= 4 )); then
        mods+="Ctrl + "
        mask=$((mask - 4))
    fi
    if (( mask >= 1 )); then
        mods+="Shift + "
        mask=$((mask - 1))
    fi

    echo "$mods"
}

parse_hyprland() {
    # Use hyprctl binds -j for native JSON output
    local binds
    binds=$(hyprctl binds -j 2>/dev/null)

    if [[ -z "$binds" ]]; then
        echo '{"error": "hyprctl not available"}' > "$OUTPUT_JSON"
        return 1
    fi

    # Process with jq if available
    if command -v jq > /dev/null; then
        echo "$binds" | jq -r '
            [.[] | select(.description != "") | {
                key: (
                    (if .modmask >= 64 then "Super + " else "" end) +
                    (if (.modmask % 64) >= 8 then "Alt + " else "" end) +
                    (if (.modmask % 8) >= 4 then "Ctrl + " else "" end) +
                    (if (.modmask % 4) >= 1 then "Shift + " else "" end) +
                    .key
                ),
                desc: .description,
                dispatcher: .dispatcher,
                arg: .arg
            }]
        ' > "$OUTPUT_JSON"
    else
        # Fallback: save raw JSON
        echo "$binds" > "$OUTPUT_JSON"
    fi
}

parse_niri() {
    local config="$1"

    if [[ ! -f "$config" ]]; then
        echo '{"error": "niri config not found"}' > "$OUTPUT_JSON"
        return 1
    fi

    local json='['
    local first=true
    local current_category=""

    while IFS= read -r line; do
        # Detect category from decorative comments (// │ ... │)
        if [[ "$line" == *"│"*"│"* ]]; then
            # Extract text between first │ and last │, then trim
            current_category=$(echo "$line" | sed 's/[^│]*│//;s/│[^│]*$//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        fi

        # Parse keybinding with hotkey-overlay-title
        if [[ "$line" =~ hotkey-overlay-title=\"([^\"]+)\" ]]; then
            local desc="${BASH_REMATCH[1]}"

            # Extract key combo - remove leading spaces, then everything after key combo
            local key=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*hotkey-overlay.*//')
            # Remove extra attributes like allow-when-locked=true, repeat=false, cooldown-ms=150, allow-inhibiting=false
            key=$(echo "$key" | sed 's/[[:space:]]*allow-when-locked[^[:space:]]*//g')
            key=$(echo "$key" | sed 's/[[:space:]]*allow-inhibiting[^[:space:]]*//g')
            key=$(echo "$key" | sed 's/[[:space:]]*repeat[^[:space:]]*//g')
            key=$(echo "$key" | sed 's/[[:space:]]*cooldown-ms[^[:space:]]*//g')

            # Clean up key format
            key=$(echo "$key" | sed 's/Mod/Super/g; s/+/ + /g; s/  */ /g; s/^[[:space:]]*//;s/[[:space:]]*$//')

            if [[ -n "$key" && -n "$desc" ]]; then
                # Escape quotes
                desc=$(echo "$desc" | sed 's/"/\\"/g')
                key=$(echo "$key" | sed 's/"/\\"/g')

                if [[ "$first" == true ]]; then
                    first=false
                else
                    json+=','
                fi

                json+="{\"key\":\"$key\",\"desc\":\"$desc\",\"category\":\"$current_category\"}"
            fi
        fi
    done < "$config"

    json+=']'
    echo "$json" > "$OUTPUT_JSON"
}

generate_txt() {
    # Generate human-readable text file for Walker
    if [[ ! -f "$OUTPUT_JSON" ]]; then
        echo "No keybinds.json found" > "$OUTPUT_TXT"
        return 1
    fi

    if command -v jq > /dev/null; then
        # Process in order, outputting category headers when they change
        # Replace emojis with Nerd Font icons
        jq -r '
            reduce .[] as $item (
                {last_cat: "", output: []};
                if $item.category != .last_cat and $item.category != "" then
                    .output += ["──────────── \($item.category) ────────────"] |
                    .last_cat = $item.category
                else . end |
                .output += ["  \($item.key) → \($item.desc)"]
            ) | .output[]
        ' "$OUTPUT_JSON" 2>/dev/null | while IFS= read -r line; do
            if [[ "$line" == "────────────"* ]]; then
                # Extract category name and emoji
                cat_raw=$(echo "$line" | sed 's/─//g; s/^[[:space:]]*//; s/[[:space:]]*$//')

                # Map emoji to nerd font icon
                case "$cat_raw" in
                    *"APPLICATIONS"*)     icon="󰀻"; name="APPLICATIONS" ;;
                    *"AUDIO"*)            icon="󰎆"; name="AUDIO & MÉDIA" ;;
                    *"LUMINOSITÉ"*)       icon="󰃟"; name="LUMINOSITÉ" ;;
                    *"CAPTURES"*)         icon="󰹑"; name="CAPTURES D'ÉCRAN" ;;
                    *"GESTION FENÊTRES"*) icon="󱂬"; name="GESTION FENÊTRES" ;;
                    *"NAVIGATION FENÊTRES"*) icon="󰁌"; name="NAVIGATION FENÊTRES" ;;
                    *"DÉPLACEMENT"*)      icon="󰁍"; name="DÉPLACEMENT FENÊTRES" ;;
                    *"MONITEURS"*)        icon="󰍹"; name="NAVIGATION MONITEURS" ;;
                    *"WORKSPACES"*)       icon="󱂬"; name="WORKSPACES" ;;
                    *"REDIMENSIONNEMENT"*) icon="󰩨"; name="REDIMENSIONNEMENT" ;;
                    *"POWER"*)            icon="󰁹"; name="POWER MODES" ;;
                    *"SYSTÈME"*)          icon="󰒃"; name="SYSTÈME" ;;
                    *)                    icon=""; name="$cat_raw" ;;
                esac

                # Fixed width: 50 chars total (icon + space + dashes + name + dashes + space + icon)
                total_width=44
                name_len=${#name}
                dash_total=$((total_width - name_len - 2))  # -2 for spaces around name
                dash_left=$((dash_total / 2))
                dash_right=$((dash_total - dash_left))

                dashes_l=$(printf '─%.0s' $(seq 1 $dash_left))
                dashes_r=$(printf '─%.0s' $(seq 1 $dash_right))

                echo "$icon $dashes_l $name $dashes_r $icon"
            else
                # Convert XF86 keys to readable Fn+F names (Framework 16 layout)
                line=$(echo "$line" | sed \
                    -e 's/XF86AudioMute/Fn+F1/g' \
                    -e 's/XF86AudioLowerVolume/Fn+F2/g' \
                    -e 's/XF86AudioRaiseVolume/Fn+F3/g' \
                    -e 's/XF86AudioPrev/Fn+F4/g' \
                    -e 's/XF86AudioPlay/Fn+F5/g' \
                    -e 's/XF86AudioNext/Fn+F6/g' \
                    -e 's/XF86AudioStop/Fn+Stop/g' \
                    -e 's/XF86MonBrightnessDown/Fn+F7/g' \
                    -e 's/XF86MonBrightnessUp/Fn+F8/g' \
                    -e 's/XF86Display/Fn+F9/g' \
                    -e 's/XF86AudioMicMute/Fn+MicMute/g' \
                )
                echo "$line"
            fi
        done > "$OUTPUT_TXT"
    else
        # Simple fallback
        cat "$OUTPUT_JSON" > "$OUTPUT_TXT"
    fi
}

reload_compositor() {
    local compositor="$1"
    case "$compositor" in
        niri)
            niri msg action load-config-file 2>/dev/null
            ;;
        hyprland)
            hyprctl reload 2>/dev/null
            ;;
    esac
}

show_walker() {
    if [[ -f "$OUTPUT_TXT" ]]; then
        cat "$OUTPUT_TXT" | walker --dmenu -p "Keybinds"
    else
        echo "Run '$0 generate' first"
    fi
}

# Main
case "${1:-help}" in
    generate)
        compositor=$(detect_compositor)
        echo "Compositor: $compositor"

        case "$compositor" in
            hyprland)
                parse_hyprland
                ;;
            niri)
                parse_niri "$NIRI_CONFIG"
                ;;
            *)
                # Try both
                if [[ -f "$NIRI_CONFIG" ]]; then
                    parse_niri "$NIRI_CONFIG"
                else
                    echo "No compositor detected and no config found"
                    exit 1
                fi
                ;;
        esac

        generate_txt
        echo "Generated: $OUTPUT_JSON"
        echo "Generated: $OUTPUT_TXT"
        ;;

    reload)
        compositor=$(detect_compositor)
        echo "Reloading $compositor config..."
        reload_compositor "$compositor"
        echo "Regenerating keybinds..."
        $0 generate
        command -v notify-send > /dev/null && notify-send -u low "Karamel" "Config reloaded & keybinds updated"
        ;;

    show)
        if [[ -f "$OUTPUT_TXT" ]]; then
            cat "$OUTPUT_TXT"
        else
            echo "No keybinds.txt found. Run: $0 generate"
        fi
        ;;

    walker)
        show_walker
        ;;

    which)
        detect_compositor
        ;;

    *)
        echo "Karamel Keybinds - Parse compositor keybindings"
        echo ""
        echo "Usage: $0 <command>"
        echo ""
        echo "Commands:"
        echo "  generate  Parse config and create keybinds.json/txt"
        echo "  reload    Reload compositor config + regenerate keybinds"
        echo "  show      Display keybinds in terminal"
        echo "  walker    Open keybinds in Walker"
        echo "  which     Show detected compositor"
        ;;
esac
