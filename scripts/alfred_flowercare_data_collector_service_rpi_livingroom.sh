#!/bin/bash
clear

echo "Set env vars"
export ENVIRONMENT="production"
export MOCK="false"
export PORT=3981
export NO_SCHEDULE="true"
export ZONE="5"
export TRACE_LEVEL="debug"

echo "Get latest code"
cd ~/Alfred_FlowerCare_Data_Collector_Service
git pull

echo "Move scripts into location"
cp ~/Alfred_Infrastructure/alfred_flowercare_data_collector_service/* .

echo "Build the container"
docker-compose -f docker-compose-rpi.yml down --rmi all
docker-compose -f docker-compose-rpi.yml up -d --build

echo "Push new build to registery"
echo $DOCKER_REGISTERY_PASSWORD | docker login $DOCKER_REGISTERY_URL -u $DOCKER_REGISTERY_USERNAME --password-stdin 
docker push ${{ secrets.DOCKER_REGISTERY_URL }}/alfred_flowercare_data_collector_service_rpi
