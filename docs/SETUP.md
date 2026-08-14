# Setup

## Host Requirements

- Docker Engine (with `--privileged` support)
- Kernel module `binder_linux` available
- Portainer CE (optional, for GUI container management)

### Kernel module

Load binder before starting containers:

```bash
sudo modprobe binder_linux devices="binder,hwbinder,vndbinder"
```

Verify:

```bash
lsmod | grep binder
```

> **Note on `ashmem_linux`:** this module is **not required** on modern kernels. Confirmed working on host kernel `7.0.0-28-generic` without it — `binder_linux` alone is sufficient, as the Android runtime falls back to `memfd_create()` internally. Do not treat a missing `ashmem_linux` module as a blocker; only `binder_linux` must be loaded.

If `binder_linux` is missing entirely (`modprobe: FATAL: Module ... not found`), the host kernel does not ship it. Building it from source (`redroid-modules` project) or switching to a standard Ubuntu LTS kernel (5.15+) is required in that case.

---

## Deploying the Containers

### Option A — quick script

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
  androidboot.redroid_gpu_mode=guest
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
  androidboot.redroid_gpu_mode=guest
```

Flag notes:

| Flag | Purpose |
|---|---|
| `--privileged` | Required for binder/ashmem device access |
| `-v <volume>:/data` | Persists Android state across container restarts (see [BACKUP_RESTORE.md](BACKUP_RESTORE.md)) |
| `-p host:5555` | Maps ADB port to host; each instance needs a unique host port |
| `androidboot.redroid_gpu_mode=guest` | Software rendering; use `host` only with validated `/dev/dri` passthrough |

### Verify deployment

```bash
docker ps
docker logs -f redroid-gapps      # watch for "Boot completed"
docker logs -f redroid-non-gapps
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

First-time setup requires a **setup token**, retrievable from the container logs:

```bash
docker logs portainer | grep setup_token=
```

To skip the token requirement (only on trusted/isolated networks):

```bash
docker run -d --name portainer --restart=always \
  -p 8000:8000 -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest \
  --no-setup-token
```

---

## Open Issues

- [ ] Remote ADB access currently limited to local network / direct IP. Cloudflare Tunnel (used for other services under `anora.my.id`) does not cleanly support raw ADB TCP protocol — requires a TCP-mode tunnel config or a VNC/noVNC bridge instead of HTTP proxying.
- [x] `ashmem_linux` module unavailable on host kernel `7.0.0-28-generic` — confirmed both containers run stable without it (binder-only setup). Not yet validated under heavy GPU/app workloads.
- [ ] No noVNC/browser-based access layer set up yet (would remove client-side adb/scrcpy install requirement).

## Security Notes

- Both containers run `--privileged` — required for binder/ashmem device access, but grants elevated host access. Do not expose ADB ports (`5555`/`5581`) directly to the public internet without additional access control (firewall allowlist, VPN, or SSH tunnel).
