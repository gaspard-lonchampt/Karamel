# === POWER MANAGEMENT ===
# Framework 16 - uses platform_profile + framework_tool + auto-cpufreq
# (power-profiles-daemon and TLP are NOT used)

# Framework laptop CLI tool for battery/EC control
AddPackage framework-system  # Framework laptop system tool

# CPU frequency management - auto-switch powersave/performance based on battery
AddPackage --foreign auto-cpufreq  # Automatic CPU speed & power optimizer
