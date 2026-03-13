#!/bin/bash 
hyprctl clients -j | jq -r '.[] | select(.workspace.id != 1) | .title'
