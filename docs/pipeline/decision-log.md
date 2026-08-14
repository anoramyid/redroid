# Decision Log

## [2026-08-14] Adopsi TSA-X
- **Keputusan**: Menggunakan framework TSA-X v6.2 untuk manajemen proyek.
- **Rasional**: Meningkatkan konsistensi AI dalam menangani backup dan deployment Redroid.

## [2026-08-14] Strategi Backup
- **Keputusan**: Menggunakan `tar` via temporary container untuk backup named volumes.
- **Rasional**: Metode paling aman dan bersih dibandingkan `docker export`.
