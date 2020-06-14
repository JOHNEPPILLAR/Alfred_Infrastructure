#!/bin/bash
clear

echo "Run the container"
cd ../alfred_reverse_proxy_prod

cp -r /home/jp/DockerScripts/Certs/. ./volumes/certs/

docker-compose -f docker-compose.yml pull
docker-compose -f docker-compose.yml down --rmi all
docker-compose -f docker-compose.yml up -d
cd ..
