#!/bin/bash
clear

echo "Run the container"
cd ../NoIP
docker run --name=noip -d -v /etc/localtime:/etc/localtime -v /config/dir/path:/config coppit/no-ip
cd ..