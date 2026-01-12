# === POWER MANAGEMENT ===
# Framework 16 AMD - utilise platform_profile + fw-ectool + auto-cpufreq
# (power-profiles-daemon et TLP ne sont PAS utilisés)

# AUR: Framework EC tool for battery charge control (sustainer)
AddPackage --foreign fw-ectool-git  # Framework Laptop EC control

# CPU frequency management - auto-switch powersave/performance selon batterie
AddPackage auto-cpufreq  # Automatic CPU speed & power optimizer
