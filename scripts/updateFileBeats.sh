#!/bin/bash
clear

echo "Run the container"
cd ../filebeats
docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml up -d --build
cd ..

export ELK_HOST=""