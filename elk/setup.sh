#!/bin/bash
clear

echo "Setup/run elk docker container"
echo "------------------------------"
echo ""

export ELK_VERSION=7.9.3
export ELK_HOST=192.168.1.12:9200

echo "Runing the container..."
docker-compose down
docker-compose pull
docker-compose up -d

echo "Purge docker images..."
docker image prune -f

echo "Finished"
