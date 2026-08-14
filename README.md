# Redroid Repo
Repositori untuk manajemen instance Redroid (Android in Docker) baik versi GApps maupun Non-GApps.

## Stack
- **OS**: Linux (Ubuntu/Debian recommended)
- **Engine**: Docker
- **Android**: Redroid 11.0.0
- **Tools**: scrcpy, adb, bash

## Quick Start
1. Pastikan modul kernel `binder_linux` terpasang.
2. Jalankan `./scripts/deploy.sh` untuk inisialisasi container.
3. Gunakan `./scripts/mirror-both.sh` untuk menampilkan layar Android.
4. Gunakan `./scripts/upload-to-release.sh` untuk mengamankan backup ke GitHub Releases.

## Architecture
- **redroid-gapps**: Instance dengan Google Play Services (Port 5555).
- **redroid-non_gapps**: Instance Android murni (Port 5581).
- **Persistent Data**: Menggunakan named volumes `redroid_gapps_data` dan `redroid_nongapps_data`.

## Folder Structure
- `scripts/`: Script operasional (deploy, backup, mirror).
- `docs/`: Dokumentasi teknis mendalam.
- `.ai/`: Memori kerja untuk asisten AI (TSA-X).
- `backups/`: Lokasi hasil backup (lokal).

## License
MIT
