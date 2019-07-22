#!/bin/bash
set -x

NETWORK=${5:-host}

TAG=${4:-1.14.1}
CONTAINER=${3:-ace-audit-fixity}
REPOSITORY=${2:-ace-audit-manager}
ACTION=${1:-BUILD}
DAEMONIZE=-d

# Delete test container built from docker file
docker stop $CONTAINER
docker rm $CONTAINER

if [ "$ACTION" = "BUILD" ]; then
# Delete test image built from docker file
docker image rm $REPOSITORY:$TAG

# Create test image from docker file
docker build --rm -t $REPOSITORY:$TAG .

ACTION=DEBUG

fi

if [ "$ACTION" = "DEBUG" ]; then
    DAEMONIZE=""
    DEBUG="--user root -it --entrypoint /bin/bash"
fi

if [ "$ACTION" = "COMPOSE" ]; then

NETWORK=test_default

docker run --user root -it --entrypoint /bin/bash \
       --net=$NETWORK \
       --link db-host:test_db-host_1 \
       -e DB_HOST="db-host" \
       --tmpfs /var/log/php-fpm:uid=33,gid=33,mode=755,noexec,nodev,nosuid \
       --tmpfs /run/lock:uid=0,gid=0,mode=1777,noexec,nodev \
       --tmpfs /run/php:uid=33,gid=33,mode=775,noexec,nodev,nosuid \
       --name $CONTAINER \
       $REPOSITORY:$TAG

else

docker run $DAEMONIZE $DEBUG \
       --net=$NETWORK \
       --name $CONTAINER \
       $REPOSITORY:$TAG

fi
