# Backup & Restore

This guide covers backing up Android data (apps, settings) and container configurations for Redroid instances.

---

## Backup

### Automated Backup (Recommended)

Use the provided script to automate both configuration and data backup:

```bash
./scripts/backup-redroid.sh
```

This script will:
1. Detect mount points for `/data`.
2. Save container configuration as `.json`.
3. Compress data into a `.tar.gz` file.
4. Store results in the `backups/` directory.

### Securing Backups to Cloud

Since backup files can be large (>100MB), do not upload them to Git. Instead, use the GitHub Release script:

```bash
./scripts/upload-to-release.sh [TAG_NAME]
```

---

## Restore

### A. Restore from a Named Volume Backup

1. Ensure the volume exists or create it:
   ```bash
   docker volume create redroid_gapps_data
   ```

2. Extract data to the volume:
   ```bash
   docker run --rm -v redroid_gapps_data:/data -v $(pwd)/backups:/backup alpine \
     tar xzf /backup/redroid-gapps_data_YYYYMMDD.tar.gz -C /data
   ```

3. Re-deploy the container using `scripts/deploy.sh` or manual `docker run`.

### B. Restore Configuration

Use the `.json` files in `backups/` to verify previous environment variables and port mappings if needed.
