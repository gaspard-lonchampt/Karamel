function kpower --description "Karamel power management (Framework 16)"
    set -l state_file /tmp/karamel-power-mode

    switch $argv[1]
        case chill
            echo 40 | sudo tee /sys/class/power_supply/BAT1/charge_control_start_threshold > /dev/null
            echo 60 | sudo tee /sys/class/power_supply/BAT1/charge_control_end_threshold > /dev/null
            echo "low-power" | sudo tee /sys/firmware/acpi/platform_profile > /dev/null
            echo "chill" > $state_file
            notify-send -u low "Karamel" "🌿 Mode chill (40-60%, low-power)"
        case notso
            echo 60 | sudo tee /sys/class/power_supply/BAT1/charge_control_start_threshold > /dev/null
            echo 80 | sudo tee /sys/class/power_supply/BAT1/charge_control_end_threshold > /dev/null
            echo "balanced" | sudo tee /sys/firmware/acpi/platform_profile > /dev/null
            echo "notso" > $state_file
            notify-send -u low "Karamel" "🐎 Mode notso (60-80%, balanced)"
        case furious
            echo 0 | sudo tee /sys/class/power_supply/BAT1/charge_control_start_threshold > /dev/null
            echo 100 | sudo tee /sys/class/power_supply/BAT1/charge_control_end_threshold > /dev/null
            echo "performance" | sudo tee /sys/firmware/acpi/platform_profile > /dev/null
            echo "furious" > $state_file
            notify-send -u low "Karamel" "🔥 Mode furious (0-100%, performance)"
        case cycle
            set -l current (cat $state_file 2>/dev/null; or echo "furious")
            switch $current
                case chill
                    kpower notso
                case notso
                    kpower furious
                case '*'
                    kpower chill
            end
        case status
            set -l cap (cat /sys/class/power_supply/BAT1/capacity)
            set -l stat (cat /sys/class/power_supply/BAT1/status)
            set -l profile (cat /sys/firmware/acpi/platform_profile)
            set -l start_thresh (cat /sys/class/power_supply/BAT1/charge_control_start_threshold 2>/dev/null)
            set -l end_thresh (cat /sys/class/power_supply/BAT1/charge_control_end_threshold 2>/dev/null)
            set -l daemon_mode (cat $state_file 2>/dev/null; or echo "unknown")
            echo "🔋 Batterie: $cap% ($stat)"
            echo "⚡ Profil: $profile"
            echo "🔌 Sustainer: $start_thresh-$end_thresh%"
            echo "🤖 Mode: $daemon_mode"
        case '*'
            echo "Usage: kpower {chill|notso|furious|cycle|status}"
    end
end
