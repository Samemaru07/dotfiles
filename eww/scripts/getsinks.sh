#!/bin/bash

default=$(pactl get-default-sink)
sink_data=$(pactl list sinks)

# sink名の表示名マッピング
get_sink_label() {
    case "$1" in
        "alsa_output.pci-0000_0c_00.4.analog-stereo") echo "オンボード" ;;
        "alsa_output.pci-0000_0a_00.1.hdmi-stereo")   echo "モニタ" ;;
        *) echo "$1" ;;
    esac
}

# ポート名の表示名マッピング
get_port_label() {
    case "$1" in
        "analog-output-lineout")      echo "スピーカ" ;;
        "analog-output-headphones")   echo "ヘッドフォン" ;;
        "hdmi-output-0")              echo "HDMI" ;;
        *) echo "$1" ;;
    esac
}

echo "$sink_data" | grep -oP '(?<=Sink #)\d+' | while read -r id; do
    sink_block=$(echo "$sink_data" | awk "/^Sink #$id$/{found=1; next} found && /^Sink #/{exit} found{print}")

    name=$(echo "$sink_block" | grep "Name:" | sed 's/.*Name: //')
    desc=$(get_sink_label "$name")
    active="false"
    [[ "$name" == "$default" ]] && active="true"
    active_port=$(echo "$sink_block" | grep "Active Port:" | sed 's/.*Active Port: //')

    ports=$(echo "$sink_block" | awk '/Ports:/{found=1; next} /Active Port:/{exit} found{print}' \
        | while IFS= read -r line; do
            [[ -z "$(echo "$line" | tr -d '[:space:]')" ]] && continue
            port_name=$(echo "$line" | sed 's/^[[:space:]]*//' | cut -d':' -f1)
            port_desc=$(get_port_label "$port_name")
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
