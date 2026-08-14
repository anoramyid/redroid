# Redroid Repo
A repository for managing Redroid (Android in Docker) instances, supporting both GApps and Non-GApps versions.

## Stack
- **OS**: Linux (Ubuntu, Debian, and **Alpine Linux** supported)
- **Engine**: Docker
- **Android**: Redroid 11.0.0
- **Tools**: scrcpy, adb, bash, GitHub CLI (gh)

## Quick Start
1. Ensure the `binder` kernel feature is available (module `binder_linux` for Ubuntu/Debian, or `binderfs` for Alpine).
2. Run `./scripts/deploy.sh` to initialize the containers (auto-detects OS).
3. Use `./scripts/mirror-both.sh` to mirror the Android screens.
4. Use `./scripts/upload-to-release.sh` to secure backups to GitHub Releases.

## Architecture
- **redroid-gapps**: Instance with Google Play Services (Port 5555).
- **redroid-non_gapps**: Pure Android instance (Port 5581).
- **Persistent Data**: Uses named volumes `redroid_gapps_data` and `redroid_nongapps_data`.

## Folder Structure
- `scripts/`: Operational scripts (deploy, backup, mirror, upload).
- `docs/`: In-depth technical documentation.
- `.ai/`: Working memory for AI assistants (TSA-X framework).
- `backups/`: Local backup storage (excluded from Git).

## License
MIT
