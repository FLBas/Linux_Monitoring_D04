#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"

source $SCRIPT_DIR/process.sh

function main () {
    local START_TIME=$(date +%s)
    local log_file="/home/wsl/Desktop/Linux_Monitoring/DO4_LinuxMonitoring_v2.0-1-master/src/02/creation_log.log"
    local symbols_folder=$1
    local symbols_file=$2
    local size_file=$3
    local ERROR=0

    check_free_space
    check "$symbols_folder" "$symbols_file" "$size_file" && create "$symbols_folder" "$symbols_file" "$size_file"

    ERROR=$?

    local END_TIME=$(date +%s)
    local ALL_TIME=$(( $END_TIME - $START_TIME ))

    echo "START_TIME = $START_TIME sec"
    echo "END_TIME = $END_TIME sec"
    echo "ALL_TIME = $ALL_TIME sec"

    echo "START_TIME = $START_TIME sec" >> $log_file
    echo "END_TIME = $END_TIME sec" >> $log_file
    echo "ALL_TIME = $ALL_TIME sec" >> $log_file

    return $ERROR
}

main $1 $2 $3

echo "CODE" $?
