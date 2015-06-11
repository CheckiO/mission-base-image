#!/usr/bin/env bash

MISSION_BASE_IMAGE="checkio/mission_base"
CURRENT_DATE="$(date +'%Y.%m.%d')"

case "$1" in
'build')
echo "Building mission base images"
NEW_IMAGE=$MISSION_BASE_IMAGE":"$CURRENT_DATE

docker build -t $MISSION_BASE_IMAGE .
docker tag -f $MISSION_BASE_IMAGE $NEW_IMAGE

docker push $MISSION_BASE_IMAGE
docker push $NEW_IMAGE
echo "New image version: "$NEW_IMAGE
;;
'run')
docker run -it $MISSION_BASE_IMAGE bash
;;
esac
