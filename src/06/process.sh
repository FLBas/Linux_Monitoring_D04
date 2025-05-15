#!/bin/bash

function process {
    cat $LOG_DIR/log_nginx{0..4}.log | goaccess -o report.html --log-format=COMBINED
}