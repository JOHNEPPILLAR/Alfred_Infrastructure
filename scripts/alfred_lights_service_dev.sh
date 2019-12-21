#!/bin/bash
clear

echo "Set env vars"
export ENVIRONMENT="production"
export MOCK="true"

echo "Run the container"
cd ../alfred_lights_service
echo $DOCKER_REGISTERY_PASSWORD | docker login $DOCKER_REGISTERY_URL -u $DOCKER_REGISTERY_USERNAME --password-stdin 
docker-compose -f docker-compose.dev.yml pull
docker-compose -f docker-compose.dev.yml down --rmi all
docker-compose -f docker-compose.dev.yml up -d
cd ..