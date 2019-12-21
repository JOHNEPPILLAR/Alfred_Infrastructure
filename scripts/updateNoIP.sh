#!/bin/bash
clear

echo "Run the container"
docker run --name=noip -d -v /etc/localtime:/etc/localtime -v /config/dir/path:/config coppit/no-ip
