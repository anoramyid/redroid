#!/usr/bin/env bash
# Automated Backup for Redroid Instances
# Usage: ./scripts/backup-redroid.sh
set -euo pipefail

BACKUP_DIR="backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

backup_instance() {
    local name=$1
    local volume=$2

    echo "==> Backing up $name..."

    # Save config
    docker inspect "$name" > "$BACKUP_DIR/${name}_config_${DATE}.json"

    # Backup volume
    docker run --rm -v "$volume":/data -v "$(pwd)/$BACKUP_DIR":/backup alpine \
      tar czf "/backup/${name}_data_${DATE}.tar.gz" -C /data .

    echo "    Done: $name"
}

# Auto-detect or use defaults
echo "Starting backup process..."

# GApps
if docker ps -a --format '{{.Names}}' | grep -q "^redroid-gapps$"; then
    backup_instance "redroid-gapps" "redroid_gapps_data"
else
    echo "SKIP: redroid-gapps container not found."
fi

# Non-GApps (detecting both hyphen and underscore)
if docker ps -a --format '{{.Names}}' | grep -q "^redroid-non_gapps$"; then
    backup_instance "redroid-non_gapps" "redroid_nongapps_data"
elif docker ps -a --format '{{.Names}}' | grep -q "^redroid-non-gapps$"; then
    backup_instance "redroid-non-gapps" "redroid_nongapps_data"
else
    echo "SKIP: redroid-non-gapps container not found."
fi

echo "==> Backup complete. Files stored in $BACKUP_DIR/"
ls -lh "$BACKUP_DIR/"
