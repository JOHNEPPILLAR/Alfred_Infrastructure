#!/bin/bash
clear

echo "Set env vars"
export ENVIRONMENT="development"
export MOCK="true"

echo "Run the container"
cd ../alfred_netatmo_data_collector_service
echo $DOCKER_REGISTERY_PASSWORD | docker login $DOCKER_REGISTERY_URL -u $DOCKER_REGISTERY_USERNAME --password-stdin 
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml up -d
cd ..
