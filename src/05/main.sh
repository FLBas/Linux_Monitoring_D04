#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"

source $SCRIPT_DIR/process.sh

function main () {
    local count_files=5
    local LOG_DIR="$SCRIPT_DIR/../04"
    check $1 && process $1

    ERROR=$?
    
    return $ERROR
}

main $1

echo "CODE" $?