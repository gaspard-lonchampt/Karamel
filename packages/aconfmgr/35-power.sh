# === POWER MANAGEMENT ===
# Framework 16 AMD - utilise platform_profile + sysfs charge control + auto-cpufreq
# (power-profiles-daemon et TLP ne sont PAS utilisés)

# CPU frequency management - auto-switch powersave/performance selon batterie
AddPackage auto-cpufreq  # Automatic CPU speed & power optimizer
