# Setup

## Host Requirements

- Docker Engine (with `--privileged` support)
- Kernel features: **Binder** and **memfd** (or ashmem)
- Portainer CE (optional, for GUI container management)

### Kernel Requirements

#### Standard Linux (Ubuntu/Debian)
Load the `binder_linux` module:
```bash
sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"
```

#### Alpine Linux
On Alpine, Binder is usually built-in (`CONFIG_ANDROID_BINDERFS=y`) rather than a module. You must mount `binderfs` manually:

```bash
sudo mkdir -p /dev/binderfs
sudo mount -t binder binder /dev/binderfs
```

To make this persistent, add to `/etc/fstab`:
`binder /dev/binderfs binder stats=global 0 0`

> **Note on `ashmem`:** Modern kernels (like Alpine 3.20+ with kernel 6.6+) have removed `ashmem`. Redroid handles this automatically via the `androidboot.use_memfd=1` flag, which is included in the `scripts/deploy.sh` script.

---

## Deploying the Containers

### Option A — quick script (Recommended)
This script auto-detects Alpine Linux and handles binderfs mounting:
```bash
bash scripts/deploy.sh
```

### Option B — manual `docker run`

**redroid-gapps** (Android + Google Apps):

```bash
docker run -itd --restart=always --privileged \
  --name redroid-gapps \
  -v redroid_gapps_data:/data \
  -p 5555:5555 \
  redroid/redroid:11.0.0_gapps \
  androidboot.redroid_width=1080 \
  androidboot.redroid_height=1920 \
  androidboot.redroid_gpu_mode=guest \
  androidboot.use_memfd=1
```

**redroid-non-gapps** (Android only, lightweight):

```bash
docker run -itd --restart=always --privileged \
  --name redroid-non-gapps \
  -v redroid_nongapps_data:/data \
  -p 5581:5555 \
  redroid/redroid:11.0.0-latest \
  androidboot.redroid_width=1080 \
  androidboot.redroid_height=1920 \
  androidboot.redroid_gpu_mode=guest \
  androidboot.use_memfd=1
```

---

## Management via Portainer

Portainer CE install:

```bash
docker volume create portainer_data

docker run -d \
  --name portainer \
  --restart=always \
  -p 8000:8000 \
  -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

Access: `https://<host-ip>:9443`

---

## Open Issues

- [ ] Remote ADB access currently limited to local network.
- [x] Alpine Linux support (binderfs + memfd).
- [ ] Browser-based access (noVNC).

## Security Notes
- Both containers run `--privileged`. Do not expose ADB ports (`5555`/`5581`) directly to the public internet.
