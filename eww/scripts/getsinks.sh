#!/bin/bash

default=$(pactl get-default-sink)
sink_data=$(pactl list sinks)

echo "$sink_data" | grep -oP '(?<=Sink #)\d+' | while read -r id; do
sink_block=$(echo "$sink_data" | awk "/^Sink #$id$/{found=1; next} found && /^Sink #/{exit} found{print}")

    name=$(echo "$sink_block" | grep "Name:" | sed 's/.*Name: //')
    desc=$(echo "$sink_block" | grep "Description:" | sed 's/.*Description: //')
    active="false"
    [[ "$name" == "$default" ]] && active="true"
    active_port=$(echo "$sink_block" | grep "Active Port:" | sed 's/.*Active Port: //')

    ports=$(echo "$sink_block" | awk '/Ports:/{found=1; next} /Active Port:/{exit} found{print}' \
        | while IFS= read -r line; do
            [[ -z "$(echo "$line" | tr -d '[:space:]')" ]] && continue
            port_name=$(echo "$line" | sed 's/^[[:space:]]*//' | cut -d':' -f1)
            port_desc=$(echo "$line" | grep -oP ':\s*\K[^(]+' | head -1 | sed 's/[[:space:]]*$//')
            if echo "$line" | grep -q "not available"; then
                available="false"
            else
                available="true"
            fi
            jq -n \
                --arg name "$port_name" \
                --arg desc "$port_desc" \
                --argjson available "$available" \
                '{"name": $name, "desc": $desc, "available": $available}'
        done | jq -sc '.')

    jq -n \
        --argjson id "$id" \
        --arg name "$name" \
        --arg desc "$desc" \
        --argjson active "$active" \
        --arg active_port "$active_port" \
        --argjson ports "$ports" \
        '{"id": $id, "name": $name, "desc": $desc, "active": $active, "active_port": $active_port, "ports": $ports}'
done | jq -sc '.'
