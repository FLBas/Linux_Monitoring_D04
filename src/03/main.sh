#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"

source $SCRIPT_DIR/process.sh

function main () {
    FILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local log_file="$FILE_DIR/../02/creation_log.log"
    local ERROR=0


    check $1 && process $1

    ERROR=$?
    
    return $ERROR
}

main $1

echo "CODE" $?