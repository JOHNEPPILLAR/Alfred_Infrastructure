#!/bin/bash
clear

echo "Run the container"
cd ../registry
cp ~/DockerScripts/Certs/* ~/DockerScripts/Alfred_Infrastructure/registry/certs/.

docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml up -d
cd ..