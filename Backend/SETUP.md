# Setup Backend Perisai Nusantara

## Prerequisites

- Python 3.8 atau lebih tinggi
- pip (Python package manager)

## Quick Start

### 1. Clone dan Setup

```bash
# Masuk ke direktori backend
cd Backend

# Jalankan script setup (Linux/Mac)
./start.sh

# Atau untuk Windows
start.bat
```

### 2. Manual Setup

Jika script otomatis tidak berfungsi, ikuti langkah manual:

```bash
# Buat virtual environment
python3 -m venv venv

# Aktifkan virtual environment
# Linux/Mac:
source venv/bin/activate
# Windows:
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Jalankan server
python run.py
```

### 3. Inisialisasi Database

```bash
# Setelah server berjalan, buka terminal baru dan jalankan:
python init_db.py
```

## Struktur Project

```
Backend/
├── main.py                 # Entry point FastAPI
├── database.py            # Konfigurasi database
├── models.py              # Model SQLAlchemy
├── schemas.py             # Pydantic schemas
├── auth.py                # Sistem autentikasi
├── utils.py               # Fungsi utilitas
├── requirements.txt       # Dependencies Python
├── run.py                 # Script menjalankan server
├── init_db.py            # Script inisialisasi database
├── start.sh              # Script setup Linux/Mac
├── start.bat             # Script setup Windows
├── update_frontend_urls.py # Update URL frontend
├── README.md             # Dokumentasi utama
├── SETUP.md              # Dokumentasi setup
└── database/             # Direktori database SQLite
    └── perisai_nusantara.db
```

## API Endpoints

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

## Database Schema

### Tabel Users
- `id` (Primary Key)
- `nip` (Unique)
- `name`
- `email` (Unique)
- `password` (Hashed)
- `id_site`
- `site`
- `id_position`
- `status`
- `created_at`
- `updated_at`

### Tabel Buku_Tamu
- `id` (Primary Key)
- `no_visitor` (Unique)
- `tanggal`
- `nama`
- `telepon`
- `alamat`
- `keperluan`
- `foto` (Base64)
- `filename`
- `created_by` (Foreign Key)
- `created_at`

### Tabel Buku_Paket
- `id` (Primary Key)
- `id_paket` (Unique)
- `tanggal`
- `nama_penerima`
- `barang`
- `kurir`
- `nama_petugas`
- `foto` (Base64)
- `created_by` (Foreign Key)
- `created_at`

### Tabel Laporan
- `id` (Primary Key)
- `laporanid` (Unique)
- `nama`
- `laporan`
- `tanggal`
- `foto` (Base64)
- `created_by` (Foreign Key)
- `created_at`

### Tabel Activities
- `id` (Primary Key)
- `activityid` (Unique)
- `name`
- `activity`
- `images` (Base64)
- `datetime`
- `created_by` (Foreign Key)
- `created_at`

### Tabel Emergency_Contacts
- `id` (Primary Key)
- `nama`
- `no_telepon`
- `service`
- `alamat`
- `created_at`

### Tabel Attendance
- `id` (Primary Key)
- `nik` (Foreign Key)
- `tagid`
- `checkin` (Boolean)
- `timestamp`

### Tabel Accident_Reports
- `id` (Primary Key)
- `nik_reporter` (Foreign Key)
- `the_time`
- `the_date`
- `title`
- `id_site`
- `related_figure`
- `figures_remark`
- `chronology`
- `taken_action`
- `image` (Base64)
- `created_at`

## Konfigurasi

### Environment Variables
Buat file `.env` berdasarkan `env_example.txt`:

```env
DATABASE_URL=sqlite:///./database/perisai_nusantara.db
SECRET_KEY=your-secret-key-here-change-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
HOST=0.0.0.0
PORT=8000
DEBUG=True
ALLOWED_ORIGINS=["*"]
```

### CORS Configuration
Backend sudah dikonfigurasi untuk menerima request dari semua origin (`*`). Untuk production, ubah ke domain yang spesifik.

## Troubleshooting

### Port 8000 sudah digunakan
```bash
# Cek proses yang menggunakan port 8000
lsof -i :8000

# Kill proses tersebut
kill -9 <PID>

# Atau gunakan port lain
uvicorn main:app --reload --host 0.0.0.0 --port 8001
```

### Database error
```bash
# Hapus database dan buat ulang
rm -rf database/
mkdir database
python run.py
python init_db.py
```

### Dependencies error
```bash
# Update pip
pip install --upgrade pip

# Install ulang dependencies
pip install -r requirements.txt --force-reinstall
```

## Development

### Menambah Endpoint Baru
1. Tambah model di `models.py`
2. Tambah schema di `schemas.py`
3. Tambah endpoint di `main.py`
4. Update dokumentasi

### Testing
```bash
# Test API dengan curl
curl -X GET "http://localhost:8000/"

# Test login
curl -X POST "http://localhost:8000/login-anggota" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@perisai.com","password":"admin123"}'
```

## Production Deployment

### Security Checklist
- [ ] Ubah `SECRET_KEY` di production
- [ ] Set `DEBUG=False`
- [ ] Konfigurasi CORS dengan domain spesifik
- [ ] Gunakan HTTPS
- [ ] Setup logging
- [ ] Backup database secara berkala

### Deployment Options
- **Docker**: Buat Dockerfile
- **Heroku**: Setup Procfile
- **AWS**: Gunakan EC2 atau Lambda
- **GCP**: Gunakan Cloud Run atau App Engine

## Support

Untuk bantuan lebih lanjut:
1. Cek dokumentasi API di http://localhost:8000/docs
2. Lihat log server untuk error details
3. Pastikan semua dependencies terinstall dengan benar 