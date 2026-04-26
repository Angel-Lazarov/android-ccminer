#!/bin/sh

# if pgrep -f "ccminer" >/dev/null 2>&1; then
#     echo "[✓] ccminer already running, exiting"
#     exit 0
# fi

exec ~/ccminer/ccminer -c ~/ccminer/config.json -q