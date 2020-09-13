docker run --rm \
  -e INFLUXDB_ADMIN_ENABLED=true \
  -e INFLUXDB_ADMIN_USER=$INFLUXDB_ADMIN_USER \
  -e INFLUXDB_ADMIN_PASSWORD=$INFLUXDB_ADMIN_PASSWORD \
  -e INFLUXDB_DB=telegraf \
  -e INFLUXDB_USER=$INFLUXDB_USER \
  -e INFLUXDB_USER_PASSWORD=$INFLUXDB_PASSWORD \
  -v influxdb:/var/lib/influxdb \
  influxdb /init-influxdb.sh