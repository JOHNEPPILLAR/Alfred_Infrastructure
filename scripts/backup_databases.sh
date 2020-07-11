#!/bin/bash

echo "Clear backup folder"
docker exec -it timescaledb bash -c 'rm -rf /mnt/local_share/Current/TimeScaleDB *'

echo "Backing up databases"
docker exec -it timescaledb bash -c 'pg_basebackup -l "Backup created at $(hostname) on $(date)" -U postgres -D /mnt/local_share/Current/TimeScaleDB'
