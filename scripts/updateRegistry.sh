#!/bin/bash
clear

echo "Run the container"
cd ../registry

docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml up -d --build
cd ..