#!/bin/bash
clear

echo "Setup/run elk docker container"
echo "------------------------------"
echo ""

export ELK_VERSION=7.9.3
export ELK_HOST=192.168.1.12:9200

echo "Set permissions on config file"
chown root filebeat/config/filebeat.yml
chmod go-w filebeat/config/filebeat.yml

SETUP_ELK="$1"
if [ -z "$SETUP_ELK" ]
then
    echo ""
    echo "Setup ELK or just Filebeats?"
    select SETUP_ELK in "ELK" "Filebeats";
    do
        break
    done
fi

echo ""
case $SETUP_ELK in
    ELK )   echo "Setup policies..."
            docker-compose down
            docker-compose pull
            docker-compose up -d
            ;;
    Filebeats ) echo "Skipping vault setup"
                docker-compose down filebeats
                docker-compose pull filebeats
                docker-compose up -d filebeats
                ;;
esac

echo "Purge docker images..."
docker image prune -f

echo "Finished"
