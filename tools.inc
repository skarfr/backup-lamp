#!/bin/bash

function in_array() {
    local array="$1[@]" #array variable: it may contains the value we are looking for
    local value=$2      #string/numerical variable: the value we are looking for, within the array

    for ele in "${!array}"; do
        if [[ $ele == $value ]]; then
            echo "true" #we found it !
            return 0
        fi
    done
    echo "false"        #we looped through the whole array without finding it
    return 0
}
