#!/usr/bin/env bash
# Upload backups to GitHub Releases
# Usage: ./scripts/upload-to-release.sh [TAG_NAME]
set -euo pipefail

BACKUP_DIR="backups"
TAG_NAME="${1:-v$(date +%Y%m%d-%H%M)}"
RELEASE_TITLE="Backup Redroid $TAG_NAME"
RELEASE_NOTES="Automated backup upload for Redroid GApps and Non-GApps instances.
Date: $(date)"

# Check if there are files to upload
if [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
    echo "ERROR: No files found in $BACKUP_DIR to upload."
    exit 1
fi

echo "==> Creating GitHub Release: $TAG_NAME..."
gh release create "$TAG_NAME" \
    --title "$RELEASE_TITLE" \
    --notes "$RELEASE_NOTES" \
    --repo anoramyid/redroid

echo "==> Uploading assets one by one..."

for file in "$BACKUP_DIR"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo "    Uploading $filename..."
        gh release upload "$TAG_NAME" "$file" --repo anoramyid/redroid --clobber
        echo "    Done: $filename"
    fi
done

echo "==> All files uploaded successfully to: https://github.com/anoramyid/redroid/releases/tag/$TAG_NAME"
