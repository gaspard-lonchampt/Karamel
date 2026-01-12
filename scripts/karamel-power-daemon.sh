#!/bin/bash
# Karamel Power Daemon - Auto-switch based on CPU/GPU load
# Only active when on AC power

HYSTERESIS_COUNT=0
HYSTERESIS_THRESHOLD=6  # 6 * 5s = 30s
CURRENT_MODE=""
CHECK_INTERVAL=5
STATE_FILE="/tmp/karamel-power-mode"

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

get_cpu_load() {
    # Get CPU usage by sampling /proc/stat twice (1s interval)
    local cpu1=($(awk '/^cpu / {print $2,$3,$4,$5}' /proc/stat))
    sleep 1
    local cpu2=($(awk '/^cpu / {print $2,$3,$4,$5}' /proc/stat))

    local user=$((cpu2[0] - cpu1[0]))
    local nice=$((cpu2[1] - cpu1[1]))
    local system=$((cpu2[2] - cpu1[2]))
    local idle=$((cpu2[3] - cpu1[3]))
    local total=$((user + nice + system + idle))

    if [ "$total" -gt 0 ]; then
        echo $(( (user + system) * 100 / total ))
    else
        echo 0
    fi
}

get_gpu_load() {
    # AMD GPU busy percent
    cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null || echo 0
}

is_on_ac() {
    [ "$(cat /sys/class/power_supply/ACAD/online 2>/dev/null)" = "1" ]
}

get_target_mode() {
    local load=$1
    if [ "$load" -lt 30 ]; then
        echo "chill"
    elif [ "$load" -lt 70 ]; then
        echo "notso"
    else
        echo "furious"
    fi
}

# Read initial mode from state file
if [ -f "$STATE_FILE" ]; then
    CURRENT_MODE=$(cat "$STATE_FILE")
fi

log "Karamel Power Daemon started"

while true; do
    if ! is_on_ac; then
        # On battery - let auto-cpufreq handle everything
        if [ -n "$CURRENT_MODE" ]; then
            log "Switched to battery - pausing daemon"
            CURRENT_MODE=""
        fi
        HYSTERESIS_COUNT=0
        sleep $CHECK_INTERVAL
        continue
    fi

    CPU_LOAD=$(get_cpu_load)
    GPU_LOAD=$(get_gpu_load)

    # Use max of CPU and GPU
    if [ "$CPU_LOAD" -gt "$GPU_LOAD" ]; then
        LOAD=$CPU_LOAD
    else
        LOAD=$GPU_LOAD
    fi

    TARGET=$(get_target_mode $LOAD)

    if [ "$TARGET" != "$CURRENT_MODE" ]; then
        HYSTERESIS_COUNT=$((HYSTERESIS_COUNT + 1))
        if [ "$HYSTERESIS_COUNT" -ge "$HYSTERESIS_THRESHOLD" ]; then
            log "Switching: $CURRENT_MODE -> $TARGET (load: $LOAD%)"
            fish -c "kpower $TARGET"
            CURRENT_MODE=$TARGET
            echo "$TARGET" > "$STATE_FILE"
            HYSTERESIS_COUNT=0
        fi
    else
        HYSTERESIS_COUNT=0
    fi

    sleep $CHECK_INTERVAL
done
