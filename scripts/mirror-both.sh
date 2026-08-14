#!/usr/bin/env bash
# Mirror both redroid instances simultaneously with scrcpy.
# Usage: ./mirror-both.sh <HOST-IP>
set -euo pipefail

HOST_IP="${1:-localhost}"

echo "==> Connecting ADB..."
adb connect "${HOST_IP}:5555"
adb connect "${HOST_IP}:5581"

echo "==> Launching scrcpy for both instances..."
scrcpy -s "${HOST_IP}:5555" --window-title "Redroid GApps" --max-size 1024 --bit-rate 2M &
scrcpy -s "${HOST_IP}:5581" --window-title "Redroid Non-GApps" --max-size 1024 --bit-rate 2M &

wait
