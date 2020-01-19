#!/bin/bash

echo "Backing up databases"
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/arlo.bak arlo -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/commute.bak commute -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/devices.bak devices -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/dyson.bak dyson -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/flowercare.bak flowercare -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/lights.bak lights -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/netatmo.bak netatmo -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/schedules.bak schedules -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/tplink.bak tplink -U postgres'

echo "Copy bak files to local storage"
cp /var/lib/docker/volumes/timescaledb_data/_data/*.bak /home/jp/DockerBackup/TimeScaleDB

echo "Copy bak files to longterm storage"
cp /home/jp/DockerBackup/TimeScaleDB/* /mnt/local_share/Current/TimeScaleDB
