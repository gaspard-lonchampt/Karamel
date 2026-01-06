# Set default XCompose that is triggered with CapsLock
tee ~/.XCompose >/dev/null <<EOF
include "%H/.local/share/karamel/default/xcompose"

# Identification
<Multi_key> <space> <n> : "$KARAMEL_USER_NAME"
<Multi_key> <space> <e> : "$KARAMEL_USER_EMAIL"
EOF
