#!/bin/bash

wifi_info=$(nmcli -t -f active,ssid,signal dev wifi 2>/dev/null | grep -v '^いいえ' | grep -v '^$')

if [[ -z "$wifi_info" ]]; then
    echo '{"icon": "󰤭", "ssid": "Disconnected", "strength": 0}'
    exit 0
fi

ssid=$(echo "$wifi_info" | cut -d: -f2)
signal=$(echo "$wifi_info" | cut -d: -f3)

if   [[ "$signal" -ge 75 ]]; then icon="󰤨"
elif [[ "$signal" -ge 50 ]]; then icon="󰤥"
elif [[ "$signal" -ge 25 ]]; then icon="󰤢"
else                               icon="󰤟"
fi

echo "{\"icon\": \"$icon\", \"ssid\": \"${ssid^^}\", \"strength\": $signal}"
