# Show installation environment variables
gum log --level info "Installation Environment:"

env | grep -E "^(KARAMEL_CHROOT_INSTALL|KARAMEL_ONLINE_INSTALL|KARAMEL_USER_NAME|KARAMEL_USER_EMAIL|USER|HOME|KARAMEL_REPO|KARAMEL_REF|KARAMEL_PATH)=" | sort | while IFS= read -r var; do
  gum log --level info "  $var"
done
