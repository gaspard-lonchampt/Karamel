KARAMEL_MIGRATIONS_STATE_PATH=~/.local/state/karamel/migrations
mkdir -p $KARAMEL_MIGRATIONS_STATE_PATH

for file in ~/.local/share/karamel/migrations/*.sh; do
  touch "$KARAMEL_MIGRATIONS_STATE_PATH/$(basename "$file")"
done
