#!/bin/bash



function create {
    local count_dir=$(shuf -i 1-100 -n 1)
    local cur_date=$(date +%d%m%y)
    local i=0
    local j

    local size_num=$(echo $size_file | tr -dc '0-9')
    local size_unit=$(echo $size_file | tr -dc 'a-zA-Z' | head -c 1)
    local size_full_unit=$(echo $size_file | tr -dc 'a-zA-Z')
    local fullsize=$size_num$size_unit

    
    echo "Лог создания папок и файлов (Дата: $(date))" > "$log_file"
    echo "----------------------------------------------------------------------------------------------------------------" >> "$log_file"
    echo "Количество созданных папок = $count_dir" >> "$log_file"

    while [ $i -le $count_dir ]; do 
        local path_random_dir=$(find_random_dir)
        local subfolder_name=$(generate_name $symbols_folder)
        subfolder_name=$subfolder_name'_'$cur_date
        sudo mkdir -p $path_random_dir/$subfolder_name

        echo "Папка: $path_random_dir/$subfolder_name , Дата создания: $(date), Размер: $(du -sh $path_random_dir/$subfolder_name | awk '{print $1}')" >> "$log_file"

        local count_files=$(shuf -i 1-15 -n 1)
        for((j=0; j < $count_files; j++)); do

            local file_name=$(generate_name $symbols_file)

            check_free_space

            sudo fallocate -l $fullsize $path_random_dir/$subfolder_name/$file_name

            local file_size=$(stat -c %s $path_random_dir/$subfolder_name/$file_name)
            local file_date=$(stat -c %y $path_random_dir/$subfolder_name/$file_name)
            echo "Файл: $path_random_dir/$subfolder_name/$file_name, Дата создания: $file_date, Размер: $file_size $size_full_unit" >> "$log_file"

        done

        echo "----------------------------------------------------------------------------------------------------------------" >> "$log_file"
        ((i++))
    done
}

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

    local random_len=$(shuf -i 5-7 -n 1)
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
    
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "ERROR: One of the parameters is empty. "
        echo "Usage: $0 <param1> <param2> <param3>"
        ERROR=1
    elif [[ ! "$1" =~ ^[a-zA-Z]{5,7}+$ ]]; then
        echo "ERROR: Param symbols_folder(3) only a-z A-Z and len 5-7 symbols"
        ERROR=1
    elif [[ ! "$2" =~ ^[a-zA-Z]{5,7}\.[a-zA-Z]{1,3}$ ]]; then
        echo "ERROR: Incorrect parametr 'symbols_file', check that the input is correct"
        echo "       Need only symbols a-z A-Z (name len 5-7, extension len 1-3)"
        ERROR=1
    elif [[ ! "$3" =~ ^[0-9]+(B|Kb|Mb|Gb|Tb|Pb|Eb|Zb|Yb)$ ]]; then
        echo "ERROR: Invalid size"
        echo "Only B|Kb|Mb|Gb|Tb|Pb|Eb|Zb|Yb"
        ERROR=1
    fi

    return $ERROR
}

function check_free_space {

    free_space=$(df -h / | awk 'NR==2 {print $4}' | sed 's/G//')

    if [ "$free_space" -le 1 ]; then
        echo "ERROR: There is less than 1 GB left in the system."
        exit 1
    fi
}

function find_random_dir {
    local dir="/home/folder"

    local r_dir=$(sudo find $dir -type d -writable | grep -Ev '/bin|/sbin' | shuf -n 1)

    echo "$r_dir"
}
