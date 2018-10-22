#!/bin/bash

set -e

IMAGE_NAME=maap-get_coda_files

# Check that the correct number of arguments were provided.
if [[ $# -lt 5 || $# -gt 6 ]]; then
    echo "Usage: sh docker-run.sh <user> <json-input-path> <flow-name> <variable-name> <coda-output-path> <--prev-coda-input-path>"
    exit
fi

# Assign the program arguments to bash variables.
USER=$1
INPUT_JSON=$2
FLOW_NAME=$3
VARIABLE_NAME=$4
OUTPUT_CODA=$5

# Build an image for this pipeline stage.
docker build -t "$IMAGE_NAME" .

# Create a container from the image that was just built.
container="$(docker container create --env USER="$USER" --env FLOW_NAME="$FLOW_NAME" --env VARIABLE_NAME="$VARIABLE_NAME" "$IMAGE_NAME")"

function finish {
    # Tear down the container when done.
    docker container rm "$container" >/dev/null
}
trap finish EXIT

# Copy input data into the container
docker cp "$INPUT_JSON" "$container:/data/input.json"

# Run the container
docker start -a -i "$container"

# Copy the output data back out of the container
mkdir -p "$(dirname "$OUTPUT_CODA")"
docker cp "$container:/data/output-coda.csv" "$OUTPUT_CODA"