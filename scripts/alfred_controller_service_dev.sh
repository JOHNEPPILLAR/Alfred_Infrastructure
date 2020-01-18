#!/bin/bash
clear

echo "Set env vars"
export ENVIRONMENT="development"
export MOCK="false"
export PORT=3978
export ALFRED_FLOWERCARE_SERVICE="https://kidsroomserver:3981"
export ALFRED_COMMUTE_SERVICE="https://alfred_commute_service:3979"
export ALFRED_NETATMO_SERVICE="https://alfred_netatmo_data_collector_service:3979"
export ALFRED_DYSON_SERVICE="https://alfred_dyson_data_collector_service:3979"
export ALFRED_LIGHTS_SERVICE="https://alfred_lights_service:3979"

echo "Run the container"
cd ../alfred_controller_service
echo $DOCKER_REGISTERY_PASSWORD | docker login $DOCKER_REGISTERY_URL -u $DOCKER_REGISTERY_USERNAME --password-stdin 
docker-compose -f docker-compose.dev.yml pull
docker-compose -f docker-compose.dev.yml down --rmi all
docker-compose -f docker-compose.dev.yml up -d
cd ..
