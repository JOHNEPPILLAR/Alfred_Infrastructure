#!/bin/bash
clear

echo "Login to vault"
vault login -address=$VAULT_URL $VAULT_TOKEN

echo "Set env vars"
VAULES=$(vault read -address=$VAULT_URL -format=json secret/alfred_common/DataStoreUser)
DATA_STORE_USER=$(echo $VAULES | jq .data.data)
export DATA_STORE_USER=$(echo "${DATA_STORE_USER:1:${#DATA_STORE_USER}-2}")
VAULES=$(vault read -address=$VAULT_URL -format=json secret/alfred_common/DataStoreUserPassword)
DATA_STORE_USER_PASSWORD=$(echo $VAULES | jq .data.data)
export DATA_STORE_USER_PASSWORD=$(echo "${DATA_STORE_USER_PASSWORD:1:${#DATA_STORE_USER_PASSWORD}-2}")

echo "Run the container"
docker-compose down
docker-compose pull
docker-compose up -d --build

echo "Tidy up"
export DATA_STORE_USER=""
export DATA_STORE_USER_PASSWORD=""