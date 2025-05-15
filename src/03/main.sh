#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"

source $SCRIPT_DIR/process.sh

function main () {
    local log_file="/home/wsl/Desktop/Linux_Monitoring/DO4_LinuxMonitoring_v2.0-1-master/src/02/creation_log.log"
    local ERROR=0

    check $1 && process $1

    ERROR=$?
    
    return $ERROR
}

main $1

echo "CODE" $?