#!/usr/bin/env bash

bar_size=40
bar_char_done="#"
bar_char_todo="-"
bar_percentage_scale=2

show_progress() {
    local curr="$1"
    local total="$2"

    local percent=$(( 100 * curr / total ))
    local done_slots=$(( curr * bar_size / total ))
    local todo_slots=$(( bar_size - done_slots ))

    local done_str=""
    for ((i = 0; i < done_slots; i++)); do
        done_str+="$bar_done_char"
    done
    local todo_str=""
    for ((i = 0; i < todo_slots; i++)); do
        todo_str+="$bar_todo_char"
    done

    printf "\rProgress : [%s%s] %3d%%" \
        "$done_str" "$todo_str" "$percent"

	if [ "$curr" -eq "$total" ]; then
        echo '' 
    fi
}

