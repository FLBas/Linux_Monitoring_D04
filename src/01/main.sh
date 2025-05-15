#!/bin/bash

#check / process

SCRIPT_DIR="$(dirname "$0")"

source $SCRIPT_DIR/process.sh

function main () {
    FILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local log_file="$FILE_DIR/creation_log.log"
    local ABSOLUTE_PATH=$1
    local num_subfolders=$2
    local symbols_folder=$3
    local num_files=$4
    local symbols_file=$5
    local size_=$6
    local ERROR=0

    check_free_space
    check "$ABSOLUTE_PATH" "$num_subfolders" "$symbols_folder" "$num_files" "$symbols_file" "$size_" && 
    create "$ABSOLUTE_PATH" "$num_subfolders" "$symbols_folder" "$num_files" "$symbols_file" "$size_"

    ERROR=$?


    return $ERROR
}

main $1 $2 $3 $4 $5 $6

echo "CODE" $?