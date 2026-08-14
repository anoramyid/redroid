# Pipeline Docs

## Branching
- `main`: Produksi / Stabil.
- `dev`: Pengembangan fitur baru.

## Dev Flow
1. Update `docs/` jika ada perubahan konfigurasi.
2. Uji script di lingkungan lokal.
3. Jalankan backup sebelum perubahan besar pada container.

## Build & Deploy
- `scripts/deploy.sh`: Inisialisasi container.
- `scripts/backup-redroid.sh`: Backup data.

## Definition of Done
- [ ] Script berjalan tanpa error.
- [ ] Dokumentasi diperbarui.
- [ ] Memory Update dilakukan di `.ai/memory.md`.
