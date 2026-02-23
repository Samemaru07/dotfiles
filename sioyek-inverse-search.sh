#!/bin/bash
# Wrapper script for Sioyek inverse search to Neovim in WSL
# Usage: sioyek-inverse-search.sh <windows_file_path> <line_number>

# Input validation
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <windows_path> <line_number>"
    exit 1
fi

WINDOWS_PATH="$1"
LINE_NUMBER="$2"

# Convert Windows path to WSL path
WSL_PATH=$(wslpath -u "$WINDOWS_PATH")

# Find the most recently modified Neovim socket
# This assumes Neovim creates a socket in standard locations
SOCKET=$(ls -t /run/user/$(id -u)/nvim.*.0 2>/dev/null | head -n1)
if [[ -z "$SOCKET" ]]; then
    SOCKET=$(ls -t /tmp/nvim*/0 2>/dev/null | head -n1)
fi

# Function to escape paths for Vim commands
escape_path() {
    echo "$1"
}

# ESCAPED_PATH=$(escape_path "$WSL_PATH")

# Function to focus WezTerm window
focus_wezterm() {
    # Execute PowerShell script to focus WezTerm
    # Using specific path to powershell and script
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Bypass -File "C:\\Users\\TUFGamingB550Plus\\System\\focus-wezterm.ps1" >/dev/null 2>&1
}

if [[ -n "$SOCKET" ]]; then
    # Use nvr if available, otherwise nvim --server
    if command -v nvr &> /dev/null; then
        nvr --servername "$SOCKET" -c "e $WSL_PATH" -c "$LINE_NUMBER" -c "normal! zz"
        focus_wezterm
    else
        # Using remote-send to simulate typing commands
        # First ensure we are in normal mode (<C-\><C-N>)
        # Then edit the file and go to line
        nvim --server "$SOCKET" --remote-send "<C-\><C-N>:e $WSL_PATH<CR>:$LINE_NUMBER<CR>zz"
        focus_wezterm
    fi
else
    # Fallback: Open a new Neovim instance if no server is found
    # This might be annoying if multiple windows open, but better than nothing
    nvim "+$LINE_NUMBER" "$WSL_PATH"
fi
