#!/bin/bash
# Wrapper script for Sioyek on WSL to handle path conversion and forward search

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

CMD_ARGS=("--reuse-window")

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
"/mnt/c/Users/TUFGamingB550Plus/System/sioyek-release-windows/sioyek-release-windows/sioyek.exe" "${CMD_ARGS[@]}" >/dev/null 2>&1 &


