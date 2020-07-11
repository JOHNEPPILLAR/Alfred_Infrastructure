#!/bin/bash
echo "Backing up databases"
docker exec -it timescaledb bash -c 'pg_basebackup -l "Backup created at $(hostname) on $(date)" -U postgres -D /mnt/local_share/Current/TimeScaleDB'
