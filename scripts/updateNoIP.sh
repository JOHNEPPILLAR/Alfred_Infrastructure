#!/bin/bash
clear

echo "Get latest container"
docker pull coppit/no-ip

echo "Remove old container"
docker rm -f noip

echo "Run updated container"
cd ../NoIP
docker run -d --restart=always --name=noip -v /etc/localtime:/etc/localtime -v /config/dir/path:/config coppit/no-ip
cd ..