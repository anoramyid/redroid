# Changelog

All notable changes to this deployment are documented here.

## 2026-08-14

- **Integrated TSA-X Framework**: Initialized AI Engineering OS structure (`.ai/memory.md`, pipeline docs).
- **Automated Backup System**: Created `scripts/backup-redroid.sh` to handle automated volume backups and config snapshots.
- **GitHub Release Automation**: Created `scripts/upload-to-release.sh` to manage large backup assets via GitHub Releases (bypassing Git 100MB limit).
- **Alpine Linux Support**: Added support for Alpine hosts, including automated `binderfs` mounting and `memfd` compatibility.
- **Globalized Documentation**: Translated all project documentation to English.
- Documented simultaneous dual-instance scrcpy mirroring (gapps + non-gapps).
- Confirmed `ashmem_linux` not required on modern kernels — binder-only setup validated.
- Portainer CE configuration documented for GUI management.

## 2026-06-02

- `redroid-gapps` first deployed (port `5581:5555`)
