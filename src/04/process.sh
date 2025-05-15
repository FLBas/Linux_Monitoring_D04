#!/bin/bash

function create_log {

    local i
    local j

    for((i=0; i < 5;i++)); do
        local random_num=$(shuf -i 100-1000 -n 1)   
        for((j=0; j < $random_num;j++)); do
            echo ""$(generate_ip)" - - ["$(generate_date)"] \""$(generate_method)" "$(generate_url)" HTTP/1.1\" $(generate_responce_code) $(generate_bytes_size) \"https://example.com\" \"$(generate_user_agent)\"" >> "log_nginx$i.log" 
        done
    done

}

function generate_ip {
    
    while :;do
        
        local a=$((RANDOM % 223 + 1))

        if [[ "$a" -eq 127 ]]; then
            continue
        fi

        local b=$((RANDOM % 256))
        local c=$((RANDOM % 256))
        local d=$((RANDOM % 256))

        break
    done

    echo "$a.$b.$c.$d"
}

function generate_responce_code {

    local ar_codes=(200, 201, 400, 401, 403, 404, 500, 501, 502, 503)

    local code=$(shuf -e "${ar_codes[@]}" -n 1 | sed 's/,$//')

    echo "$code"
}

function generate_method {

    local ar_methods=("GET" "POST" "PUT" "PATCH" "DELETE")

    local method=$(shuf -e "${ar_methods[@]}" -n 1)

    echo "$method"
}

function generate_date {
    local date=$(date +"%d/%b/%Y:%H:%M:%S %z")

    echo "$date"
} 

function generate_user_agent {
    local usr_agent=$(shuf user_agent.conf -n 1)

    echo "$usr_agent"
}

function generate_url {
    local random_path="/"
    local extensions=("html" "jpg" "png" "css" "js" "php")

    for i in {1..3}; do  
        random_segment=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 8)
        if [[ $i -eq 3 ]]; then
            random_path+=$random_segment
        else
            random_path+=$random_segment"/"
        fi
    done

    local random_extension=${extensions[$RANDOM % ${#extensions[@]}]}

    echo "$random_path"."$random_extension"
}

function generate_bytes_size {
  echo $(shuf -i 100-5000 -n1)
}
