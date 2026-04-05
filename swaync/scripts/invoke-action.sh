#!/bin/bash
APP="$1"
hyprctl dispatch focuswindow "class:^(${APP,,})$"
