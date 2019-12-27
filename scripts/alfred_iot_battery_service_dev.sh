#!/bin/bash
clear

echo "Set env vars"
export ENVIRONMENT="development"
export MOCK="true"

echo "Run the container"
cd ../alfred_iot_battery_service
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml up -d
cd ..
