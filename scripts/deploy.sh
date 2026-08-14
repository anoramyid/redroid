#!/usr/bin/env bash
# Deploy redroid-gapps and redroid-non-gapps containers.
# See docs/SETUP.md for details.
set -euo pipefail

# --- Kernel Requirements ---

# Detect Alpine Linux
if [ -f /etc/alpine-release ]; then
    echo "==> Alpine Linux detected. Handling binderfs..."
    if [ ! -d /dev/binderfs ]; then
        sudo mkdir -p /dev/binderfs
    fi
    # Mount binderfs if not already mounted
    if ! mountpoint -q /dev/binderfs; then
        sudo mount -t binder binder /dev/binderfs || {
            echo "ERROR: Could not mount binderfs. Is CONFIG_ANDROID_BINDERFS=y enabled in your kernel?"
            exit 1
        }
    fi
    echo "    binderfs mounted at /dev/binderfs"
else
    echo "==> Standard Linux detected. Loading binder_linux module..."
    sudo modprobe binder_linux devices="binder,hwbinder,vndbinder" || {
      echo "WARNING: binder_linux could not be loaded. Check 'docs/SETUP.md' for troubleshooting."
    }
fi

# --- Deployment ---

echo "==> Creating persistent volumes..."
docker volume create redroid_gapps_data
docker volume create redroid_nongapps_data

# Common flags for stability on modern kernels (including Alpine 3.20+)
COMMON_BOOT_FLAGS="androidboot.redroid_width=1080 \
androidboot.redroid_height=1920 \
androidboot.redroid_gpu_mode=guest \
androidboot.use_memfd=1"

echo "==> Deploying redroid-gapps (Android + Google Apps) on port 5555..."
docker run -itd --restart=always --privileged \
  --name redroid-gapps \
  -v redroid_gapps_data:/data \
  -p 5555:5555 \
  redroid/redroid:11.0.0_gapps \
  $COMMON_BOOT_FLAGS

echo "==> Deploying redroid-non-gapps (Android only) on port 5581..."
docker run -itd --restart=always --privileged \
  --name redroid-non-gapps \
  -v redroid_nongapps_data:/data \
  -p 5581:5555 \
  redroid/redroid:11.0.0-latest \
  $COMMON_BOOT_FLAGS

echo "==> Done. Check status with: docker ps"
echo "==> Watch boot logs with: docker logs -f redroid-gapps"
