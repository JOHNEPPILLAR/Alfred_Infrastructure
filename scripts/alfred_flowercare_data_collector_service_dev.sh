#!/bin/bash
clear

echo "Set env vars"
export ENVIRONMENT="development"
export MOCK="true"
export PORT=3978

echo "Run the container"
cd ../alfred_flowercare_data_collector_service
echo $DOCKER_REGISTERY_PASSWORD | docker login $DOCKER_REGISTERY_URL -u $DOCKER_REGISTERY_USERNAME --password-stdin 
docker-compose -f docker-compose-dev.yml down --rmi all
docker-compose -f docker-compose-dev.yml pull
docker-compose -f docker-compose-dev.yml up -d
docker logout
cd ..
docker restart reverse_proxy
docker image prune -f