#!/bin/bash
clear

echo "Login to vault"
vault login -address=$VAULT_URL $VAULT_TOKEN

echo "Set env vars"
VAULES=$(vault read -address=$VAULT_URL -format=json secret/alfred/production)
export DATA_STORE_USER_PASSWORD=$(echo $VAULES | jq .data.DataStoreUserPassword)

echo "Run the container"
cd ../timescale_db
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml up -d
cd ..

export DATA_STORE_USER_PASSWORD=""