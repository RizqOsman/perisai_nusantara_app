# Perisai Nusantara Backend API

Backend FastAPI untuk aplikasi Perisai Nusantara GuardApp.

## Fitur

- **Autentikasi**: Login dengan email dan password
- **Buku Tamu**: Manajemen data tamu dengan foto
- **Buku Paket**: Manajemen paket yang diterima
- **Laporan**: Sistem pelaporan harian
- **Aktivitas**: Tracking aktivitas petugas
- **Kontak Darurat**: Daftar kontak emergency
- **Absensi**: Sistem absensi dengan NFC
- **Laporan Kecelakaan**: Pelaporan insiden

## Instalasi

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Jalankan aplikasi:
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

3. Inisialisasi database dengan data sample:
```bash
curl -X POST "http://172.15.1.21:8000/init-db"
```

## Endpoints

### Autentikasi
- `POST /login-anggota` - Login user

### Buku Tamu
- `POST /daftar-tamu` - Tambah data tamu
- `GET /buku-tamu` - Ambil semua data tamu

### Buku Paket
- `POST /daftar-paket` - Tambah data paket
- `GET /buku-paket` - Ambil semua data paket

### Laporan
- `POST /laporan` - Tambah laporan
- `GET /laporan` - Ambil semua laporan

### Aktivitas
- `POST /activity` - Tambah aktivitas
- `GET /activity` - Ambil semua aktivitas

### Kontak Darurat
- `POST /emergency-contact` - Tambah kontak darurat
- `GET /emergency-contact` - Ambil semua kontak darurat

### Absensi
- `POST /attendance` - Catat absensi
- `GET /attendance` - Ambil data absensi

### Laporan Kecelakaan
- `POST /accident-report` - Tambah laporan kecelakaan
- `GET /accident-report` - Ambil semua laporan kecelakaan

### User Management
- `POST /users` - Tambah user
- `GET /users` - Ambil semua user

### Utility
- `GET /` - Health check
- `POST /init-db` - Inisialisasi database

## Database

Menggunakan SQLite dengan file database di `database/perisai_nusantara.db`

### Tabel:
- `users` - Data user/petugas
- `buku_tamu` - Data tamu
- `buku_paket` - Data paket
- `laporan` - Data laporan
- `activities` - Data aktivitas
- `emergency_contacts` - Kontak darurat
- `attendance` - Data absensi
- `accident_reports` - Laporan kecelakaan

## Konfigurasi

- Port default: 8000
- Database: SQLite
- JWT Secret: "your-secret-key-here-change-in-production" (ubah untuk production)

## Dokumentasi API

Setelah menjalankan server, buka:
- Swagger UI: http://172.15.1.21:8000/docs
- ReDoc: http://172.15.1.21:8000/redoc 