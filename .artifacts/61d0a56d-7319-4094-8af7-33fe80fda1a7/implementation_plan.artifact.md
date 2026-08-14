# Implementasi Framework TSA-X & Automasi Backup Redroid

Proyek ini akan diatur menggunakan framework **TSA-X** untuk manajemen pengerjaan, serta ditambahkan fitur automasi backup untuk instance Redroid (GApps & Non-GApps).

## User Review Required

> [!IMPORTANT]
> Saya mendeteksi instance bernama `redroid-non_gapps` (menggunakan underscore) di sistem Anda, sedangkan script `deploy.sh` merujuk ke `redroid-non-gapps` (menggunakan hyphen). Saya akan menyesuaikan script backup agar mencakup keduanya atau menggunakan deteksi otomatis.

## Rencana Perubahan

### 1. Inisialisasi TSA-X (AI Engineering OS)
* **Pindah Memori**: Memindahkan `memory.md` ke `.ai/memory.md`.
* **Dokumen Standar**: Membuat `PIPELINE.md`, `CONTRIBUTING.md`, dan melengkapi folder `docs/pipeline/`.
* **Update README**: Menyesuaikan format `README.md` dengan standar TSA-X.

### 2. Automasi Backup & Git
* **Script Backup Baru**: Membuat `scripts/backup-redroid.sh` yang akan:
    * Melakukan `docker inspect` untuk menyimpan konfigurasi.
    * Melakukan backup data volume `/data` menggunakan `tar` ke dalam folder `backups/`.
* **Inisialisasi Git**: Menjalankan `git init` untuk melacak perubahan kode dan dokumentasi.
* **Persiapan Upload**: Menyiapkan instruksi agar user bisa menghubungkan ke remote repository (GitHub/GitLab).

### 3. Eksekusi Backup
* Menjalankan proses backup untuk kedua instance Redroid saat ini.
* Hasil backup akan disimpan secara lokal di folder `backups/` dalam proyek ini.

## Open Questions

> [!NOTE]
> 1. **Stack Proyek**: Saya akan mencatatnya sebagai `Redroid (Docker) | Shell Scripting`. Apakah setuju?
> 2. **Lokasi Backup**: Apakah Anda ingin hasil backup `.tar.gz` disimpan di dalam folder proyek ini (agar bisa di-upload ke git, *hati-hati dengan ukuran file*) atau di folder luar?

## Rencana Verifikasi

### Automated Tests
- Menjalankan `scripts/backup-redroid.sh` dan memverifikasi keberadaan file output.
- Menjalankan `git status` untuk memastikan repositori terinisialisasi.

### Manual Verification
- Verifikasi struktur folder `.ai/` dan isi `memory.md`.
- Simulasi `MEMORY UPDATE` pertama.
