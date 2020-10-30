#!/bin/bash
clear

echo "Setup/run filebeats docker container"
echo "------------------------------------"
echo ""

export ELK_HOST=192.168.1.12:9200

echo "Runing the container..."
docker-compose -f filebeats/docker-compose.yml down
docker-compose -f filebeats/docker-compose.yml pull
docker-compose -f filebeats/docker-compose.yml up -d --build

echo "Purge docker images..."
docker image prune -f

echo "Finished"
