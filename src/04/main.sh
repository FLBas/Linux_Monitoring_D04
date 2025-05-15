#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"

source $SCRIPT_DIR/process.sh

function main () {
    
    create_log

    ERROR=$?
    
    return $ERROR
}

main

echo "CODE" $?