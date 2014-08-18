#!/bin/bash

# Do a Packer build
packer build --only=docker ${1} ./packer.io.json

# Import build artifact as Docker image
echo "Importing the newly built image into docker..."
docker import - < gameeso_docker.tar gameeso_staging

# Build a new production Docker image using metadata only Dockerfile
echo "Add in Docker metadata"
docker build -t="gameeso_prod" ./config/dockerfiles/
echo "Final gameeso_prod image built, ready for docker save"

docker save 'gameeso_prod' > gameeso_docker_final.tar

# Delete the previous base image
echo "Cleaning up..."
rm -f gameeso_docker.tar
#docker rmi -f gameeso_staging gameeso_prod

echo -e "\n\n"
echo "Done! You can now import or upload your gameeso docker image."
echo "It's called 'gameeso_docker_final.tar'."
echo "Import using 'docker import - <  gameeso_docker_final.tar gameeso'"
