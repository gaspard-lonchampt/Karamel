# Aliases Mobilic - tunnels et connexions DB Scalingo
# Note: pas de -i, utilise l'agent SSH (keychain charge la clé au démarrage)
alias prod_dbtunnel 'scalingo --app mobilic-api db-tunnel SCALINGO_POSTGRESQL_URL'
alias staging_dbtunnel 'scalingo --app mobilic-api-staging db-tunnel SCALINGO_POSTGRESQL_URL'
alias sandbox_dbtunnel 'scalingo --app mobilic-api-sandbox db-tunnel SCALINGO_POSTGRESQL_URL'
alias prod_db 'scalingo --app mobilic-api pgsql-console'
