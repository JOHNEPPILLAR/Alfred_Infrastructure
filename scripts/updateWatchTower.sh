#!/bin/bash

echo "Login to vault"
vault login -address=$VAULT_URL $VAULT_TOKEN

echo "Set env vars"
VAULES=$(vault read -address=$VAULT_URL -format=json secret/alfred/production)
export SLACK_WEB_HOOK=$(echo $VAULES | jq .data.SlackWebHook)

echo "Run the container"
cd ../watchtower
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml up -d
cd ..
