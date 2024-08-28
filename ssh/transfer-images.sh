#!/bin/bash

read -r -p "Digit SSH user: " SSH_USER
read -r -p "Digit SSH host: " SSH_HOST
read -r -p "Digit SSH port: " SSH_PORT

images=$(docker images --format '{{.Repository}}:{{.Tag}}' | grep '^antonio3a/')

for image in $images; do
  echo "Loading image: $image"
  image_size=$(docker image inspect "$image" --format='{{.Size}}')
  docker save "$image" | pv -s "$image_size" | bzip2 | ssh -p "$SSH_PORT" "$SSH_USER"@"$SSH_HOST" docker load
done
