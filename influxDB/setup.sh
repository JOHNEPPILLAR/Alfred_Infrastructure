#!/bin/bash
clear

echo "Login to vault"
vault login -address=$VAULT_URL $VAULT_TOKEN

echo "Set env vars"
VAULES=$(vault read -address=$VAULT_URL -format=json secret/alfred_common/InfluxToken)
INFLUX_TOKEN=$(echo $VAULES | jq .data.data)
export INFLUX_TOKEN=$(echo "${INFLUX_TOKEN:1:${#INFLUX_TOKEN}-2}")

echo "Run the container"
docker-compose down
docker-compose pull
docker-compose up -d --build

echo "Tidy up"
export INFLUX_TOKEN=""