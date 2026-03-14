#!/bin/bash
# Wrapper script for Sioyek on WSL to handle path conversion and forward search

# Resolve Windows username dynamically (falls back to cmd.exe if $WIN_USER not set)
WIN_USER="${WIN_USER:-$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')}"

# Path to sioyek.exe — override via SIOYEK_EXE environment variable if needed
SIOYEK_EXE="${SIOYEK_EXE:-/mnt/c/Users/$WIN_USER/System/sioyek-release-windows/sioyek-release-windows/sioyek.exe}"

# Initialize variables
PDF_FILE=""
TEX_FILE=""
LINE_NUMBER=""
OTHER_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --forward-search-file)
            TEX_FILE="$2"
            shift 2
            ;;
        --forward-search-line)
            LINE_NUMBER="$2"
            shift 2
            ;;
        -*)
            OTHER_ARGS+=("$1")
            shift
            ;;
        *)
            if [[ -z "$PDF_FILE" ]]; then
                PDF_FILE="$1"
            else
                OTHER_ARGS+=("$1")
            fi
            shift
            ;;
    esac
done

if [[ -z "$PDF_FILE" ]]; then
    exit 1
fi

WIN_PDF_PATH=$(wslpath -w "$PDF_FILE")

# Use --reuse-window to prevent opening new instances
# Use --nofocus to prevent Sioyek from stealing focus (keep nvim active)
CMD_ARGS=("--reuse-window" "--nofocus")

if [[ -n "$TEX_FILE" ]]; then
    WIN_TEX_PATH=$(wslpath -w "$TEX_FILE")
    # Using array expansion to properly handle spaces in paths
    CMD_ARGS+=("--forward-search-file" "$WIN_TEX_PATH")
fi

if [[ -n "$LINE_NUMBER" ]]; then
    CMD_ARGS+=("--forward-search-line" "$LINE_NUMBER")
fi

# Add the PDF file path
CMD_ARGS+=("$WIN_PDF_PATH")

# Add other arguments if any
if [[ ${#OTHER_ARGS[@]} -gt 0 ]]; then
    CMD_ARGS+=("${OTHER_ARGS[@]}")
fi

# Execute Sioyek
"$SIOYEK_EXE" "${CMD_ARGS[@]}" >/dev/null 2>&1 &


