FROM timescale/timescaledb:latest-pg12

RUN apk add --no-cache tzdata

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*
