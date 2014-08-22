#!/bin/bash

# Do a Packer build
packer build --only=docker ${1} ./packer.io.json

# Import build artifact as Docker image
echo "Importing the newly built image into docker..."
docker import - < gameeso_docker.tar gameeso_staging

# Build a new production Docker image using metadata only Dockerfile
echo "Add in Docker metadata"
docker build -t="gameeso" ./config/dockerfiles/
echo "Final gameeso image built, ready for docker save"

docker save 'gameeso' > gameeso_docker_final.tar

# Delete the previous base image
echo "Cleaning up..."
rm -f gameeso_docker.tar
docker rmi -f gameeso_staging gameeso

echo -e "\n\n"
echo "Done! You can now import or upload your gameeso docker image."
echo "It's called 'gameeso_docker_final.tar'."
echo "Import using 'docker load < gameeso_docker_final.tar'"
