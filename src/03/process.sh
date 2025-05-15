#!/bin/bash

function check {
    if [ $# -ne 1 ]; then
        echo "Ошибка: Скрипт принимает только 1 параметр"
        ERROR=1
    elif [[ ! $1 =~ ^[1-3]$ ]]; then
        echo "Ошибка: Неверный параметр (1-3)"
        ERROR=1
  fi

  return $ERROR
}

function process {

    if [[ $1 -eq 1 ]]; then
        delete_log
        echo "Система очищена с помощью лог файла"
    elif [[ $1 -eq 2 ]]; then
        delete_date_time
        echo "Система очищена с помощью даты и времени"
    elif [[ $1 -eq 3 ]]; then
        delete_mask
        echo "Система очищена с помощью маски"
    fi

}


function delete_log {

    while read -r line; do
        local folder=$(echo "$line" | grep 'Папка' | awk '{print $2}' | sed 's/,$//')
        local file=$(echo "$line" | grep 'Файл' | awk '{print $2}' | sed 's/,$//')
        
        if [[ -n "$folder" ]]; then
            sudo rm -rf "$folder"
        fi  

        if [[ -n "$file" ]]; then
            sudo rm -rf "$file"
        fi  

    done < $log_file

}

function delete_date_time {
    read -p "Введи дату и вермя начала промежутка в формате \"yyyy-mm-dd HHMM\":" start
    read -p "Введи дату и вермя конца промежутка в формате \"yyyy-mm-dd HHMM\":" end

    echo "Найдены и будут удалены такие файлы/папки в промежутке: $start - $end"
    read -p "Продолжить удаление? (y/n): " confirm
    if [[ $confirm == "y" ]]; then
        sudo find /home/folder -newermt "$start" ! -newermt "$end" -delete
    fi
    
}

function delete_mask {
    
    read -p "Введи маску (например, *_120525): " mask

    echo "Найдены и будут удалены такие файлы/папки:"
    sudo find /home/folder \( -type d -o -type f \) -name "$mask"
    read -p "Продолжить удаление? (y/n): " confirm
    if [[ $confirm == "y" ]]; then
        sudo find /home/folder -type d -name "$mask" -exec rm -rf {} +
        sudo find /home/folder -type f -name "$mask" -exec rm -f {} +
        echo "Удаление завершено"
    else
        echo "Удаление отменено"
    fi
}