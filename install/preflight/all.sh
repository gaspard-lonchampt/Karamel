source $KARAMEL_INSTALL/preflight/guard.sh
source $KARAMEL_INSTALL/preflight/begin.sh
run_logged $KARAMEL_INSTALL/preflight/show-env.sh
run_logged $KARAMEL_INSTALL/preflight/pacman.sh
run_logged $KARAMEL_INSTALL/preflight/migrations.sh
run_logged $KARAMEL_INSTALL/preflight/first-run-mode.sh
run_logged $KARAMEL_INSTALL/preflight/disable-mkinitcpio.sh
