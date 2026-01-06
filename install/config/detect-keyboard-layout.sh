# Copy over the keyboard layout that's been set in Arch during install to Niri
conf="/etc/vconsole.conf"
niriconf="$HOME/.config/niri/config.kdl"

# Niri uses KDL format for keyboard config:
# input {
#     keyboard {
#         xkb {
#             layout "us"
#             variant "..."
#         }
#     }
# }

if grep -q '^XKBLAYOUT=' "$conf"; then
  layout=$(grep '^XKBLAYOUT=' "$conf" | cut -d= -f2 | tr -d '"')
  # Update layout in Niri config
  if [[ -f "$niriconf" ]]; then
    sed -i "s/layout \"[^\"]*\"/layout \"$layout\"/" "$niriconf"
  fi
fi

if grep -q '^XKBVARIANT=' "$conf"; then
  variant=$(grep '^XKBVARIANT=' "$conf" | cut -d= -f2 | tr -d '"')
  # Add variant to Niri config if needed
  if [[ -f "$niriconf" ]] && [[ -n "$variant" ]]; then
    # Check if variant line exists
    if grep -q 'variant "' "$niriconf"; then
      sed -i "s/variant \"[^\"]*\"/variant \"$variant\"/" "$niriconf"
    else
      # Add variant after layout line
      sed -i "/layout \"$layout\"/a\            variant \"$variant\"" "$niriconf"
    fi
  fi
fi
