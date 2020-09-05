#!/bin/bash
clear

echo "Login to vault"
vault login -address=$VAULT_URL $VAULT_TOKEN

echo "Set env vars"
VAULES=$(vault read -address=$VAULT_URL -format=json secret/alfred/production)
DATA_STORE_USER_PASSWORD=$(echo $VAULES | jq .data.DataStoreUserPassword)
export DATA_STORE_USER_PASSWORD=$(echo "${DATA_STORE_USER_PASSWORD:1:-1}")

echo "Run the container"
cd ../timescale_db
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml up -d --build
cd ..

export DATA_STORE_USER_PASSWORD=""