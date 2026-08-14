# Changelog

All notable changes to this deployment are documented here.

## 2026-08-14

- Documented BACKUP and RESTORE procedures (export/import + named-volume path)
- Confirmed `ashmem_linux` not required on kernel `7.0.0-28-generic` — binder-only setup runs stable
- Documented simultaneous dual-instance scrcpy mirroring (gapps + non-gapps)
- Portainer CE installed for container management (ports `8000`, `9443`)
- Redeployed as two separate instances:
  - `redroid-gapps` — port `5555:5555`
  - `redroid-non-gapps` — port `5581:5555`

## 2026-06-02

- `redroid-gapps` first deployed (port `5581:5555`)
