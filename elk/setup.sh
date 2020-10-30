#!/bin/bash
clear

echo "Setup/run elk docker container"
echo "------------------------------"
echo ""

echo "Runing the container..."
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml up -d --build

echo "Purge docker images..."
docker image prune -f

./setup_filebeats.sh

echo "Finished"
