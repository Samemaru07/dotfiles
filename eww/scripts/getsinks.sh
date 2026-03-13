#!/bin/bash

default=$(pactl get-default-sink)

pactl list short sinks | while IFS=$'\t' read -r id name rest; do
    desc=$(pactl list sinks | grep -A 20 "Name: $name" | grep "Description:" | sed 's/.*Description: //')
    active="false"
    [[ "$name" == "$default" ]] && active="true"
    echo "{\"id\": $id, \"name\": \"$name\", \"desc\": \"$desc\", \"active\": $active}"
done | jq -sc '.'
