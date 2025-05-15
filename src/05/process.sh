#!/bin/bash

function check {
    if [ $# -ne 1 ]; then
        echo "Ошибка: Скрипт принимает только 1 параметр"
        ERROR=1
    elif [[ ! $1 =~ ^[1-4]$ ]]; then
        echo "Ошибка: Неверный параметр (1-4)"
        ERROR=1
  fi

  return $ERROR
}

function process {
    if [[ $1 -eq 1 ]]; then
        sort_by_code
        echo "Все записи, отсортированные по коду ответа"
    elif [[ $1 -eq 2 ]]; then
        find_unic_ip
        echo "Все уникальные IP, встречающиеся в записях"
    elif [[ $1 -eq 3 ]]; then
        find_code_4xx_5xx
        echo "Все запросы с ошибками (код ответа — 4хх или 5хх)"
    elif [[ $1 -eq 4 ]]; then
        unic_ip_code_4xx_5xx
        echo "Все уникальные IP, которые встречаются среди ошибочных запросов."
    fi
}

function sort_by_code {

    local i
    for((i=0;i < "$count_files";i++)); do
        awk '{print $9}' $LOG_DIR/log_nginx$i.log | sort -k 9
        
    done
    #вариант с обьединением всех файлов и выовод
    # cat $LOG_DIR/log_nginx{0..4}.log | awk '{print}' | sort -k 9
}


function find_unic_ip {

    local i
    for((i=0;i < "$count_files";i++)); do
        awk '{print}' $LOG_DIR/log_nginx$i.log | uniq -u
    done
}

function find_code_4xx_5xx {

    local i
    for((i=0;i < "$count_files";i++)); do
        awk '{if ($9 ~ /^4/ || $9 ~ /^5/) print}' $LOG_DIR/log_nginx$i.log
        
    done
}

function unic_ip_code_4xx_5xx {

    local i
    for((i=0;i < "$count_files";i++)); do
        awk '{if ($9 ~ /^4/ || $9 ~ /^5/) print}' $LOG_DIR/log_nginx$i.log | uniq -u
    done
}