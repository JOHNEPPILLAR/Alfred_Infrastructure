#!/bin/bash

echo "Login to vault"
vault login -address=$VAULT_URL $VAULT_TOKEN

echo "Set env vars"
VAULES=$(vault read -address=$VAULT_URL -format=json secret/alfred/production)
SLACK_WEB_HOOK=$(echo $VAULES | jq .data.SlackWebHook)
export SLACK_WEB_HOOK=$(echo "${SLACK_WEB_HOOK:1:-1}")

echo "Runing the container..."
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml up -d --build
docker logout

echo "Purge docker images..."
docker image prune -f

echo "Finished"