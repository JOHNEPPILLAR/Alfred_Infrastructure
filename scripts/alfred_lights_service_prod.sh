#!/bin/bash
clear

echo "Set env vars"
export ENVIRONMENT="production"
export MOCK="false"

echo "Run the container"
cd ../alfred_lights_service
echo $DOCKER_REGISTERY_PASSWORD | sudo docker login $DOCKER_REGISTERY_URL -u $DOCKER_REGISTERY_USERNAME --password-stdin 
sudo docker-compose -f docker-compose.yml pull
sudo docker-compose -f docker-compose.yml down --rmi all
sudo docker-compose -f docker-compose.yml up -d
cd ..