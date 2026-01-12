#!/bin/bash
# Karamel Workspace - Helper for workspace management

case "${1:-help}" in
    kill)
        # Get current workspace ID
        current_ws=$(niri msg --json focused-window 2>/dev/null | jq -r '.workspace_id // empty')
        
        if [[ -z "$current_ws" ]]; then
            notify-send -u low "Karamel" "Aucune fenêtre sur ce workspace"
            exit 0
        fi
        
        # Get all window IDs on current workspace
        windows=$(niri msg --json windows | jq -r ".[] | select(.workspace_id == $current_ws) | .id")
        
        count=$(echo "$windows" | wc -w)
        
        # Close each window
        for id in $windows; do
            niri msg action close-window --id "$id" 2>/dev/null
        done
        
        notify-send -u low "Karamel" "$count fenêtre(s) fermée(s)"
        ;;
    *)
        echo "Usage: $0 {kill}"
        echo "  kill  - Fermer toutes les fenêtres du workspace actuel"
        ;;
esac
