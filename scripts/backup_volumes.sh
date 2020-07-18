#!/bin/bash
echo "Copy volumes to server long term storage"
cp -r /var/lib/docker/volumes/* /mnt/local_share/Current/.

#docker exec -it timescaledb bash -c 'rm -rf /var/lib/postgresql/data/backup'
#docker exec -it timescaledb bash -c 'mkdir /var/lib/postgresql/data/backup'
#docker exec -it timescaledb bash -c 'pg_basebackup -l "Backup created at $(hostname) on $(date)" -U postgres -D /var/lib/postgresql/data/backup'

#echo "Copy to long time storage"
#cp -r /dockerVolumes/timescale_db_data/_data/backup /mnt/local_share/Current/TimeScaleDB
