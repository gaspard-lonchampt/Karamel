#!/bin/bash
# Walker keybindings menu
# Uses dynamically generated keybindings from karamel-keybinds.sh

KEYBINDS_FILE="$HOME/.config/karamel/keybinds.txt"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Generate if file doesn't exist or is empty
if [[ ! -s "$KEYBINDS_FILE" ]]; then
    "$SCRIPT_DIR/karamel-keybinds.sh" generate > /dev/null 2>&1
fi

# Display in Walker
cat "$KEYBINDS_FILE" | walker --dmenu --placeholder "Rechercher raccourcis..."
