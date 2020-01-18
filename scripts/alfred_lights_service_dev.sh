#!/bin/bash
clear

echo "Set env vars"
export ENVIRONMENT="development"
export MOCK="false"
export PORT=3978
export ALFRED_CONTROLLER_SERVICE="https://alfred_controller_service:3979"


echo "Run the container"
cd ../alfred_lights_service
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml up -d
cd ..