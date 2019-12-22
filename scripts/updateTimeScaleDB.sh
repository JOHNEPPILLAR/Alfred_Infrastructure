#!/bin/bash
clear

echo "Set env vars"
VAULES=$(vault read -format=json secret/alfred/production)
DATA_STORE_USER_PASSWORD=$(echo $VAULES | jq .data.DataStoreUserPassword)

echo "Run the container"
cd ../timescale_db
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml up -d
cd ..