#!/bin/bash
clear


echo "Login to vault"
vault login -address=$VAULT_URL $VAULT_TOKEN

echo "Set env vars"
VAULES=$(vault read -address=$VAULT_URL -format=json secret/alfred/production)
export ELK_HOST=$(echo $VAULES | jq .data.ELKHOST)

echo "Run the container"
cd ../filebeats
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml up -d --build
cd ..

export ELK_HOST=""