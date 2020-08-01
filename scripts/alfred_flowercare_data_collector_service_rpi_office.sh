#!/bin/bash
clear

echo "Set env vars"
export ENVIRONMENT="production"
export MOCK="false"
export PORT=3981
export NO_SCHEDULE="true"
export ZONE="3,4"
export TRACE_LEVEL="debug"

echo "Run the container"
cd ../alfred_flowercare_data_collector_service
echo $DOCKER_REGISTERY_PASSWORD | docker login $DOCKER_REGISTERY_URL -u $DOCKER_REGISTERY_USERNAME --password-stdin 
docker-compose -f docker-compose-rpi.yml down --rmi all
docker-compose -f docker-compose-rpi.yml pull
docker-compose -f docker-compose-rpi.yml up -d
docker logout
