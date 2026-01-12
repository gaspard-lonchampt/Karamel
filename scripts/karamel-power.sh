#!/bin/bash
# Karamel Power - TLP wrapper for Framework 16

CONFIG="$HOME/.config/karamel/power.conf"
STATE="/tmp/karamel-power-mode"
TLP_CONF="/etc/tlp.d/02-karamel-mode.conf"

# Defaults
CHILL_LIMIT=60
NOTSO_LIMIT=80
FURIOUS_LIMIT=100
CPU_THRESH=50
GPU_THRESH=40

[[ -f "$CONFIG" ]] && source "$CONFIG"

get_cpu() { awk '/^cpu / {print int(100-($5*100/($2+$3+$4+$5+$6+$7+$8)))}' /proc/stat; }
get_gpu() { cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -1 || echo 0; }

set_mode() {
    local mode=$1 limit policy boost
    case $mode in
        chill)    limit=$CHILL_LIMIT;   policy="power"; boost=0 ;;
        notso)    limit=$NOTSO_LIMIT;   policy="balance_power"; boost=0 ;;
        furious)  limit=$FURIOUS_LIMIT; policy="performance"; boost=1 ;;
        *) return 1 ;;
    esac

    echo "$mode" > "$STATE"

    # Update TLP config
    sudo tee "$TLP_CONF" > /dev/null << EOF
START_CHARGE_THRESH_BAT1=$((limit-5))
STOP_CHARGE_THRESH_BAT1=$limit
CPU_ENERGY_PERF_POLICY_ON_AC=$policy
CPU_ENERGY_PERF_POLICY_ON_BAT=$policy
CPU_BOOST_ON_AC=$boost
CPU_BOOST_ON_BAT=$boost
EOF

    # Apply immediately
    sudo tlp setcharge $((limit-5)) $limit BAT1 2>/dev/null
    sudo tlp start > /dev/null

    # Notification (if available)
    local icon="⚡"
    case $mode in
        chill)   icon="🌿" ;;
        notso)   icon="🐎" ;;
        furious) icon="🔥" ;;
    esac
    command -v notify-send > /dev/null && notify-send -u low "Karamel Power" "$icon $mode (charge max $limit%)"
    return 0
}

cycle_mode() {
    local current=$(cat "$STATE" 2>/dev/null || echo "chill")
    local next
    case $current in
        chill)   next="notso" ;;
        notso)   next="furious" ;;
        furious) next="chill" ;;
        *)       next="chill" ;;
    esac
    set_mode "$next"
}

auto_detect() {
    local cpu=$(get_cpu) gpu=$(get_gpu)
    local current=$(cat "$STATE" 2>/dev/null || echo "chill")

    if (( cpu > 70 || gpu > 60 )); then
        [[ "$current" != "furious" ]] && set_mode furious
    elif (( cpu > CPU_THRESH || gpu > GPU_THRESH )); then
        [[ "$current" != "notso" ]] && set_mode notso
    else
        [[ "$current" != "chill" ]] && set_mode chill
    fi
}

case "${1:-status}" in
    chill|notso|furious) set_mode "$1" ;;
    cycle) cycle_mode ;;
    auto) auto_detect ;;
    daemon) while true; do auto_detect; sleep 30; done ;;
    status)
        mode=$(cat "$STATE" 2>/dev/null || echo "unknown")
        icon="⚡"
        case $mode in
            chill)   icon="🌿" ;;
            notso)   icon="🐎" ;;
            furious) icon="🔥" ;;
        esac
        echo "$icon Mode: $mode"
        echo "CPU: $(get_cpu)% | GPU: $(get_gpu)%"
        echo "Charge limit: $(cat /sys/class/power_supply/BAT1/charge_control_end_threshold 2>/dev/null || echo N/A)%"
        ;;
    *) echo "Usage: $0 {chill|notso|furious|cycle|auto|daemon|status}" ;;
esac
