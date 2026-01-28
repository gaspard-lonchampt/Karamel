# === DEVELOPMENT ===
AddPackage git # the fast distributed version control system
AddPackage cmake # A cross-platform open-source make system
AddPackage meson # High productivity build system
AddPackage jq # Command-line JSON processor
AddPackage wev # Wayland event viewer (debug keybinds)
AddPackage github-cli # The GitHub CLI

# === CONTAINERS ===
AddPackage docker # Pack, ship and run any application as a lightweight container
AddPackage docker-compose # Fast, isolated development environments using Docker

# === PYTHON ===
AddPackage pyenv # Easily switch between multiple versions of Python
AddPackage python-pip # The PyPA recommended tool for installing Python packages
AddPackage python-pipenv # Sacred Marriage of Pipfile, Pip, & Virtualenv.

# === NODE.JS ===
AddPackage pnpm # Fast, disk space efficient package manager
AddPackage --foreign fnm # Fast and simple Node.js version manager

# === DATABASE ===
AddPackage postgresql-libs # Client libraries for PostgreSQL

# === AUR HELPERS ===
AddPackage --foreign yay # Yet another yogurt. Pacman wrapper and AUR helper written in go.
AddPackage --foreign yay-debug # Detached debugging symbols for yay

# === SYSTEM CONFIG ===
AddPackage --foreign aconfmgr-git # A configuration manager for Arch Linux
