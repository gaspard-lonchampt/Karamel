#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define Karamel locations
export KARAMEL_PATH="$HOME/.local/share/karamel"
export KARAMEL_INSTALL="$KARAMEL_PATH/install"
export KARAMEL_INSTALL_LOG_FILE="/var/log/karamel-install.log"
export PATH="$KARAMEL_PATH/bin:$PATH"

# Install
source "$KARAMEL_INSTALL/helpers/all.sh"
source "$KARAMEL_INSTALL/preflight/all.sh"
source "$KARAMEL_INSTALL/packaging/all.sh"
source "$KARAMEL_INSTALL/config/all.sh"
source "$KARAMEL_INSTALL/login/all.sh"
source "$KARAMEL_INSTALL/post-install/all.sh"
