# Backup & Restore

Two things need to be backed up: the **Android data** (apps, accounts, settings inside each instance) and the **container definition** (how to recreate it).

> If containers are running **without** a named volume for `/data`, Android data lives inside the container's writable layer and will be lost on `docker rm`. Use the export/import method below for that case, or migrate to named volumes for the cleaner path.

---

## Backup

### 1. Container data (no named volume)

```bash
docker export redroid-gapps -o redroid-gapps-backup-$(date +%Y%m%d).tar
docker export redroid-non-gapps -o redroid-non-gapps-backup-$(date +%Y%m%d).tar
```

Store the resulting `.tar` files somewhere safe (external drive, NAS, cloud storage).

### 2. Container configuration

```bash
docker inspect redroid-gapps > redroid-gapps-config.json
docker inspect redroid-non-gapps > redroid-non-gapps-config.json
```

Keep the original `docker run` commands (see [SETUP.md](SETUP.md)) alongside this repo — the simplest way to recreate the setup identically.

### 3. Named volumes (recommended going forward)

Migrate to persistent volumes so backups are simple going forward:

```bash
docker volume create redroid_gapps_data
docker volume create redroid_nongapps_data
```

Then redeploy using the `-v redroid_gapps_data:/data` pattern shown in [SETUP.md](SETUP.md).

Backup a named volume:

```bash
docker run --rm -v redroid_gapps_data:/data -v $(pwd):/backup alpine \
  tar czf /backup/redroid-gapps-data-$(date +%Y%m%d).tar.gz -C /data .
```

---

## Restore

### A. Fresh setup (no prior backup)

1. Load `binder_linux` on the host (see [SETUP.md](SETUP.md)).
2. Run `scripts/deploy.sh` or the manual `docker run` commands.
3. Verify with `docker ps` and check ADB connectivity (see [USAGE.md](USAGE.md)).

### B. Restore from a `docker export` tarball

```bash
docker import redroid-gapps-backup-YYYYMMDD.tar redroid-gapps-restored:latest

docker run -itd --privileged \
  --name redroid-gapps \
  -p 5555:5555 \
  redroid-gapps-restored:latest
```

Repeat for `redroid-non-gapps` using its own backup file.

> `docker import` restores filesystem contents but **not** the original entrypoint/environment settings. If the restored container fails to boot Android properly, re-apply the original `androidboot.*` parameters manually (see [SETUP.md](SETUP.md)).

### C. Restore from a named-volume backup (recommended path)

```bash
docker volume create redroid_gapps_data

docker run --rm -v redroid_gapps_data:/data -v $(pwd):/backup alpine \
  tar xzf /backup/redroid-gapps-data-YYYYMMDD.tar.gz -C /data

docker run -itd --restart=always --privileged \
  --name redroid-gapps \
  -v redroid_gapps_data:/data \
  -p 5555:5555 \
  redroid/redroid:11.0.0_gapps \
  androidboot.redroid_width=1080 \
  androidboot.redroid_height=1920 \
  androidboot.redroid_gpu_mode=guest
```

This is the cleanest restore path — Android data comes back exactly as backed up, and the container is recreated from the original public image (no need to trust or store a custom exported image).
