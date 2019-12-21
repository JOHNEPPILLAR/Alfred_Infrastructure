#!/bin/bash
clear

echo "Run the container"
cd ../NoIP
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml up -d --build
cd ..