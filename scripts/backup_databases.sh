#!/bin/bash

echo "Backing up databases"
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/devices.bak devices -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/lights.bak lights -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/schedules.bak schedules -U postgres'
docker exec -it timescaledb bash -c 'pg_dump -Fc -f /var/lib/postgresql/data/commute.bak commute -U postgres'

echo "Copy bak files to local storage"
cp /var/lib/docker/volumes/timescaledb_data/_data/devices.bak /home/jp/DockerBackup/TimeScaleDB
cp /var/lib/docker/volumes/timescaledb_data/_data/lights.bak /home/jp/DockerBackup/TimeScaleDB/
cp /var/lib/docker/volumes/timescaledb_data/_data/schedules.bak /home/jp/DockerBackup/TimeScaleDB/
cp /var/lib/docker/volumes/timescaledb_data/_data/commute.bak /home/jp/DockerBackup/TimeScaleDB/

echo "Copy bak files to longterm storage"
cp /home/jp/DockerBackup/TimeScaleDB/* /mnt/local_share/Current/TimeScaleDB
