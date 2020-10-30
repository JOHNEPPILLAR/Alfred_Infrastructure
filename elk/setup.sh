#!/bin/bash
clear

echo "Setup/run elk docker container"
echo "------------------------------"
echo ""

echo "Loging into vault..."
vault login -address=$VAULT_URL $VAULT_TOKEN

export ELK_VERSION=7.9.3

echo "Runing the container..."
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml up -d --build

echo "Purge docker images..."
docker image prune -f

echo "Finished"
