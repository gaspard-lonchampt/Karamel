# Aliases Mobilic - tunnels et connexions DB Scalingo
alias prod_dbtunnel 'scalingo --app mobilic-api db-tunnel -i ~/.ssh/id_ed25519_mobilic_scalingo_2025 SCALINGO_POSTGRESQL_URL'
alias staging_dbtunnel 'scalingo --app mobilic-api-staging db-tunnel -i ~/.ssh/id_ed25519_mobilic_scalingo_2025 SCALINGO_POSTGRESQL_URL'
alias sandbox_dbtunnel 'scalingo --app mobilic-api-sandbox db-tunnel -i ~/.ssh/id_ed25519_mobilic_scalingo_2025 SCALINGO_POSTGRESQL_URL'
alias prod_db 'scalingo --app mobilic-api pgsql-console'
