#!/bin/bash

echo "Backing up databases"
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/arlo.bak devices -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/commute.bak commute -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/devices.bak devices -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/dyson.bak devices -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/flowercare.bak devices -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/lights.bak lights -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/netatmo.bak lights -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/schedules.bak schedules -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/tmplink.bak schedules -U postgres'

echo "Copy bak files to local storage"
cp /var/lib/docker/volumes/timescaledb_data/_data/* /home/jp/DockerBackup/TimeScaleDB

echo "Copy bak files to longterm storage"
cp /home/jp/DockerBackup/TimeScaleDB/* /mnt/local_share/Current/TimeScaleDB
