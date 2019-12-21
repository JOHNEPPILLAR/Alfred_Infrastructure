#!/bin/bash
clear

echo "Run the container"
cd ../registry
docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml up -d
cd ..