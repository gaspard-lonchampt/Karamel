# Set identification from install inputs
if [[ -n "${KARAMEL_USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$KARAMEL_USER_NAME"
fi

if [[ -n "${KARAMEL_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$KARAMEL_USER_EMAIL"
fi
