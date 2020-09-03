#!/bin/bash
clear

echo "Set env vars"
export ENVIRONMENT="production"
export MOCK="false"
export PORT=3984
export ALFRED_WEATHER_SERVICE="https://alfred_weather_service:3978"
export TRACE_LEVEL="debug"

echo "Run the container"
cd ../alfred_tp_link_service
echo $DOCKER_REGISTERY_PASSWORD | docker login $DOCKER_REGISTERY_URL -u $DOCKER_REGISTERY_USERNAME --password-stdin 
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml up -d --build
docker logout

echo "Tidy up"
docker restart reverse_proxy
docker image prune -f