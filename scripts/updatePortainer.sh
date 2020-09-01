#!/bin/bash

echo "Pull latest image"
docker pull portainer/portainer-ce

echo "Remove old image"
docker stop portainer
docker rm portainer
docker rmi portainer

echo "Run image"
docker run -d --restart=always --name=portainer -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer