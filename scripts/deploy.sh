#!/usr/bin/env bash
# Deploy redroid-gapps and redroid-non-gapps containers.
# See docs/SETUP.md for details.
set -euo pipefail

echo "==> Loading binder_linux kernel module (requires sudo)..."
sudo modprobe binder_linux devices="binder,hwbinder,vndbinder" || {
  echo "WARNING: binder_linux could not be loaded. Check 'docs/SETUP.md' for troubleshooting."
}

echo "==> Creating persistent volumes..."
docker volume create redroid_gapps_data
docker volume create redroid_nongapps_data

echo "==> Deploying redroid-gapps (Android + Google Apps) on port 5555..."
docker run -itd --restart=always --privileged \
  --name redroid-gapps \
  -v redroid_gapps_data:/data \
  -p 5555:5555 \
  redroid/redroid:11.0.0_gapps \
  androidboot.redroid_width=1080 \
  androidboot.redroid_height=1920 \
  androidboot.redroid_gpu_mode=guest

echo "==> Deploying redroid-non-gapps (Android only) on port 5581..."
docker run -itd --restart=always --privileged \
  --name redroid-non-gapps \
  -v redroid_nongapps_data:/data \
  -p 5581:5555 \
  redroid/redroid:11.0.0-latest \
  androidboot.redroid_width=1080 \
  androidboot.redroid_height=1920 \
  androidboot.redroid_gpu_mode=guest

echo "==> Done. Check status with: docker ps"
echo "==> Watch boot logs with: docker logs -f redroid-gapps"
