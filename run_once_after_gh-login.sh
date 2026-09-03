#!/bin/bash

if command -v gh >/dev/null 2>&1; then
    if ! gh auth status >/dev/null 2>&1; then
        gh auth login
    fi
fi
