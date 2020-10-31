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
    echo "Setup ELK and filebeats or just filebeats?"
    select SETUP_ELK in "ELK" "Filebeats";
    do
        break
    done
fi

echo ""
case $SETUP_ELK in
    ELK )   echo "Setup ELK and filebeats"
            docker-compose down
            docker-compose pull
            docker-compose up -d
            ;;
    Filebeats ) echo "Setup filebeats"
                docker-compose rm -f -s filebeat
                docker-compose pull
                docker-compose up -d filebeat
                ;;
esac

echo "Purge docker images..."
docker image prune -f

echo "Finished"
