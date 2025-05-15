#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"

source $SCRIPT_DIR/process.sh

function main () {
    local LOG_DIR="$SCRIPT_DIR/../04"
    process

    ERROR=$?
    
    return $ERROR
}

main

echo "CODE" $?