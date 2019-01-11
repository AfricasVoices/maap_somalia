#!/bin/bash

set -e

# Check that the correct number of arguments were provided.
if [ $# -ne 3 ]; then
    echo "Usage: sh 03_merge_scope.sh <user> <data-root> <scope-path>"
    echo "Merges SCOPE data into the traced data object"
    echo "The scope-path is the path to the csv with scope data"
    exit
fi

USER=$1
DATA_ROOT=$2
SCOPE_PATH=$3

FLOW_NAME="emergency_maap_new_pdm"

cd "../merge_scope_data"

mkdir -p "$DATA_ROOT/03 SCOPE with Messages"


echo "Merging SCOPE data"
./docker-run.sh "$USER" "$DATA_ROOT/01 Raw Messages/${FLOW_NAME}.json" \
    "$DATA_ROOT/02 Raw Contacts/contacts.json" "$SCOPE_PATH" \
    "$DATA_ROOT/03 SCOPE with Messages/${FLOW_NAME}_scope.json"
