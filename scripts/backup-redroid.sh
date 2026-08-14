#!/usr/bin/env bash
# Automated Backup for Redroid Instances
# Usage: ./scripts/backup-redroid.sh
set -euo pipefail

BACKUP_DIR="backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

backup_instance() {
    local name=$1

    echo "==> Backing up $name..."

    # Save config
    docker inspect "$name" > "$BACKUP_DIR/${name}_config_${DATE}.json"

    # Detect mount point for /data
    local mount_source=$(docker inspect "$name" --format '{{range .Mounts}}{{if eq .Destination "/data"}}{{.Source}}{{end}}{{end}}')

    if [ -n "$mount_source" ]; then
        echo "    Detected /data at: $mount_source"
        # Backup the source directory
        sudo tar czf "$BACKUP_DIR/${name}_data_${DATE}.tar.gz" -C "$mount_source" .
    else
        echo "    WARNING: No mount found for /data in $name. Android data might be inside the container layer."
        echo "    Falling back to docker export (this is slower and less clean)..."
        docker export "$name" -o "$BACKUP_DIR/${name}_export_${DATE}.tar"
    fi

    echo "    Done: $name"
}

# Auto-detect running instances
echo "Starting backup process..."

# GApps
if docker ps -a --format '{{.Names}}' | grep -q "^redroid-gapps$"; then
    backup_instance "redroid-gapps"
else
    echo "SKIP: redroid-gapps container not found."
fi

# Non-GApps (detecting both hyphen and underscore)
if docker ps -a --format '{{.Names}}' | grep -q "^redroid-non_gapps$"; then
    backup_instance "redroid-non_gapps"
elif docker ps -a --format '{{.Names}}' | grep -q "^redroid-non-gapps$"; then
    backup_instance "redroid-non-gapps"
else
    echo "SKIP: redroid-non-gapps container not found."
fi

echo "==> Backup complete. Files stored in $BACKUP_DIR/"
ls -lh "$BACKUP_DIR/"
