function kpower --description "Karamel power management (Framework 16)"
    set -l state_file /tmp/karamel-power-mode

    switch $argv[1]
        case chill
            sudo framework_tool --charge-limit 60
            echo "low-power" | sudo tee /sys/firmware/acpi/platform_profile > /dev/null
            echo "chill" > $state_file
            notify-send -u low "Karamel" "🌿 Mode chill (60%, low-power)"
        case notso
            sudo framework_tool --charge-limit 80
            echo "balanced" | sudo tee /sys/firmware/acpi/platform_profile > /dev/null
            echo "notso" > $state_file
            notify-send -u low "Karamel" "🐎 Mode notso (80%, balanced)"
        case furious
            sudo framework_tool --charge-limit 100
            echo "performance" | sudo tee /sys/firmware/acpi/platform_profile > /dev/null
            echo "furious" > $state_file
            notify-send -u low "Karamel" "🔥 Mode furious (100%, performance)"
        case gaming
            sudo framework_tool --charge-limit 80
            echo "performance" | sudo tee /sys/firmware/acpi/platform_profile > /dev/null
            echo "gaming" > $state_file
            notify-send -u low "Karamel" "🎮 Mode gaming (80%, performance)"
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
            set -l charge_limit (sudo framework_tool --charge-limit 2>/dev/null; or echo "unknown")
            set -l daemon_mode (cat $state_file 2>/dev/null; or echo "unknown")
            echo "🔋 Batterie: $cap% ($stat)"
            echo "⚡ Profil: $profile"
            echo "🔌 Charge limit: $charge_limit%"
            echo "🤖 Mode: $daemon_mode"
        case '*'
            echo "Usage: kpower {chill|notso|furious|gaming|cycle|status}"
    end
end
