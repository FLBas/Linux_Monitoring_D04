#!/bin/bash


function create {
    
    sudo mkdir -p $ABSOLUTE_PATH
    local cur_date=$(date +%d%m%y)
    local i
    local j
    
    echo "Лог создания папок и файлов (Дата: $(date))" > "$log_file"
    echo "----------------------------------------------------------------------" >> "$log_file"


    for((i=0; i < $num_subfolders; i++)); do
        local subfolder_name=$(generate_name $symbols_folder)
        subfolder_name=$subfolder_name"_"$cur_date

        sudo mkdir -p $ABSOLUTE_PATH/$subfolder_name

        echo "Папка: $ABSOLUTE_PATH/$subfolder_name, Дата создания: $(date), Размер: $(du -sh $ABSOLUTE_PATH/$subfolder_name | awk '{print $1}')" >> "$log_file"

        for((j=0; j < $num_files; j++)); do
            local file_name=$(generate_name $symbols_file)

            check_free_space

            sudo dd if=/dev/zero of=$ABSOLUTE_PATH/$subfolder_name/$file_name bs=1KB count=$size_

            file_size=$(stat -c %s $ABSOLUTE_PATH/$subfolder_name/$file_name)
            file_date=$(stat -c %y $ABSOLUTE_PATH/$subfolder_name/$file_name)
            echo "Файл: $ABSOLUTE_PATH/$subfolder_name/$file_name, Дата создания: $file_date, Размер: $file_size байт" >> "$log_file"
        done
    done

    return $ERROR
}


function create {
    
    local cur_date=$(date +%d%m%y)
    local i
    local j
    local size_num=$(echo $size_ | tr -dc '0-9')
    local size_unit=$(echo $size_ | tr -dc 'a-zA-Z' | head -c 1)
    local size_full_unit=$(echo $size_ | tr -dc 'a-zA-Z')
    local fullsize=$size_num$size_unit

    sudo mkdir -p $ABSOLUTE_PATH

    echo "Лог создания папок и файлов (Дата: $(date))" > "$log_file"
    echo "----------------------------------------------------------------------" >> "$log_file"


    for((i=0; i < $num_subfolders; i++)); do
        local subfolder_name=$(generate_name $symbols_folder)
        subfolder_name=$subfolder_name"_"$cur_date

        sudo mkdir -p $ABSOLUTE_PATH/$subfolder_name

        echo "Папка: $ABSOLUTE_PATH/$subfolder_name, Дата создания: $(date), Размер: $(du -sh $ABSOLUTE_PATH/$subfolder_name | awk '{print $1}')" >> "$log_file"

        for((j=0; j < $num_files; j++)); do
            local file_name=$(generate_name $symbols_file)

            check_free_space

            # sudo dd if=/dev/zero of=$ABSOLUTE_PATH/$subfolder_name/$file_name bs=1M count=$size_
            sudo fallocate -l $fullsize $ABSOLUTE_PATH/$subfolder_name/$file_name

            local file_size=$(stat -c %s $ABSOLUTE_PATH/$subfolder_name/$file_name)
            local file_date=$(stat -c %y $ABSOLUTE_PATH/$subfolder_name/$file_name)
            echo "Файл: $ABSOLUTE_PATH/$subfolder_name/$file_name, Дата создания: $file_date, Размер: $file_size байт" >> "$log_file"
        done
        echo "----------------------------------------------------------------------------" >> "$log_file"
    done

    return $ERROR
}

# 1 параметр список букв 
function generate_name {

    local input=$1
    local letters=""
    local extension=""


    if [[ $input == *"."* ]]; then
        letters=$(echo "$input" | cut -d '.' -f1)
        extension=$(echo "$input" | cut -d '.' -f2-)
    else
        letters="$input"
    fi

    local random_len=$(shuf -i 4-7 -n 1)
    local new_name=""

    while [ ${#new_name} -lt $random_len ]; do 
        new_name=$new_name$(echo "$letters" | fold -w1 | shuf -n 1)
    done


    for letter in $(echo "$letters" | fold -w1); do
        if [[ "$new_name" != *"$letter"* ]]; then
            new_name=$new_name$letter
        fi
    done

    if [[ ${#extension} -ne 0 ]]; then
        new_name=$new_name"."$extension
    fi

    echo "$new_name"
}

function check {
    
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] || [ -z "$6" ]; then
        echo "ERROR: One of the parameters is empty. "
        echo "Usage: $0 <param1> <param2> <param3> <param4> <param5> <param6>"
        ERROR=1
    elif [[ "$1" =~ \/$ ]]; then
        echo "ERROR: Remove the symbol '/' at the end of the path"
        ERROR=1
    elif [[ ! "$3" =~ ^[a-zA-Z]{1,7}+$ ]]; then
        echo "ERROR: Param symbols_folder(3) only a-z A-Z"
        ERROR=1
    elif [[ ! "$5" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "ERROR: Incorrect parametr 'symbols_file', check that the input is correct"
        echo "       Need only symbols a-z A-Z (name len 1-7, extension len 1-3)"
        ERROR=1
    fi

    return $ERROR
}

function check_free_space {

    free_space=$(df -h / | awk 'NR==2 {print $4}' | sed 's/G//')

    echo "-----------------------------------------------------------Free space: $free_space GB"

    if [ "$free_space" -le 1 ]; then
        echo "ERROR: There is less than 1 GB left in the system."
        exit 1
    fi
}