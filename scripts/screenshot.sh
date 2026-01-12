#!/bin/bash
# Universal screenshot script for Hyprland & niri

SCREENSHOT_DIR="$HOME/Images/Screenshots"
FILENAME="screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png"

case "$1" in
    area)
        grim -g "$(slurp -d)" - | satty -f - --copy-command=wl-copy --output-filename="$SCREENSHOT_DIR/$FILENAME"
        ;;
    screen)
        grim - | satty -f - --copy-command=wl-copy --output-filename="$SCREENSHOT_DIR/$FILENAME"
        ;;
    copy)
        grim -g "$(slurp -d)" - | wl-copy
        ;;
    *)
        # Default: area selection with annotation
        grim -g "$(slurp -d)" - | satty -f - --copy-command=wl-copy --output-filename="$SCREENSHOT_DIR/$FILENAME"
        ;;
esac
