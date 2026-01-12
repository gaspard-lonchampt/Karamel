function kpower --description "Karamel power management (Framework 16)"
    switch $argv[1]
        case chill
            sudo ectool chargecontrol normal 40 60
            echo "low-power" | sudo tee /sys/firmware/acpi/platform_profile > /dev/null
            notify-send -u low "Karamel" "🌿 Mode chill (40-60%, low-power)"
        case notso
            sudo ectool chargecontrol normal 60 80
            echo "balanced" | sudo tee /sys/firmware/acpi/platform_profile > /dev/null
            notify-send -u low "Karamel" "🐎 Mode notso (60-80%, balanced)"
        case furious
            sudo ectool chargecontrol normal 0 100
            echo "performance" | sudo tee /sys/firmware/acpi/platform_profile > /dev/null
            notify-send -u low "Karamel" "🔥 Mode furious (0-100%, performance)"
        case status
            set -l cap (cat /sys/class/power_supply/BAT1/capacity)
            set -l stat (cat /sys/class/power_supply/BAT1/status)
            set -l profile (cat /sys/firmware/acpi/platform_profile)
            set -l start_thresh (cat /sys/class/power_supply/BAT1/charge_control_start_threshold 2>/dev/null)
            set -l end_thresh (cat /sys/class/power_supply/BAT1/charge_control_end_threshold 2>/dev/null)
            set -l daemon_mode (cat /tmp/karamel-power-mode 2>/dev/null; or echo "unknown")
            echo "🔋 Batterie: $cap% ($stat)"
            echo "⚡ Profil: $profile"
            echo "🔌 Sustainer: $start_thresh-$end_thresh%"
            echo "🤖 Daemon: $daemon_mode"
        case '*'
            echo "Usage: kpower {chill|notso|furious|status}"
    end
end
