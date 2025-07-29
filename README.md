# Perisai Nusantara App

Aplikasi mobile Flutter untuk sistem manajemen keamanan dan fasilitas yang digunakan oleh petugas keamanan (security guard) dan personel fasilitas.

## 🏗️ Architecture

```
perisai_nusantara_app/
├── lib/                    # Frontend Flutter
│   ├── auth/              # Sistem autentikasi
│   ├── page/              # Halaman aplikasi
│   ├── services/          # Service layer
│   └── main.dart          # Entry point Flutter
├── Backend/               # Backend FastAPI
│   ├── main.py           # Entry point FastAPI
│   ├── models.py         # Database models
│   ├── schemas.py        # Pydantic schemas
│   ├── auth.py           # Authentication system
│   ├── database.py       # Database configuration
│   └── requirements.txt  # Python dependencies
└── README.md             # Dokumentasi utama
```

## 🚀 Quick Start

### 1. Setup Backend

```bash
# Masuk ke direktori backend
cd Backend

# Jalankan setup otomatis (Linux/Mac)
./start.sh

# Atau untuk Windows
start.bat

# Atau jalankan setup lengkap
python setup_complete.py
```

### 2. Setup Frontend

```bash
# Install Flutter dependencies
flutter pub get

# Run Flutter app
flutter run
```

## 📱 Features

### 🔐 Authentication
- Login dengan email dan password
- JWT token authentication
- Session management

### 👥 Buku Tamu
- Pendaftaran tamu dengan foto
- Data lengkap: nama, telepon, alamat, keperluan
- Tracking pengunjung

### 📦 Buku Paket
- Pencatatan paket yang diterima
- Data: nama penerima, barang, kurir, petugas
- Foto paket sebagai bukti

### 📋 Laporan
- Pembuatan laporan harian
- Upload foto laporan
- Tracking laporan berdasarkan waktu

### 🆘 Kontak Darurat
- Daftar kontak emergency
- Integrasi dengan layanan darurat
- Fungsi panggilan langsung

### 📊 Absensi
- Check-in dan check-out menggunakan NFC tag
- Integrasi dengan sistem attendance
- Validasi kehadiran

### 📈 Aktivitas
- Pencatatan aktivitas harian
- Foto aktivitas
- Tracking waktu aktivitas

### 🚨 Laporan Kecelakaan
- Pelaporan insiden/kecelakaan
- Upload foto bukti
- Data kronologi dan tindakan yang diambil

## 🛠️ Technology Stack

### Frontend
- **Framework**: Flutter (Dart)
- **State Management**: GetX
- **Storage**: GetStorage, SharedPreferences
- **HTTP Client**: http package
- **Image Handling**: image_picker
- **NFC**: nfc_manager
- **UI Components**: FontAwesome Icons

### Backend
- **Framework**: FastAPI (Python)
- **Database**: SQLite
- **ORM**: SQLAlchemy
- **Authentication**: JWT
- **Validation**: Pydantic
- **Image Processing**: Pillow

## 📊 Database Schema

### Users
- Autentikasi dan data user
- Role-based access control

### Buku_Tamu
- Data tamu dan pengunjung
- Foto dan informasi lengkap

### Buku_Paket
- Data paket yang diterima
- Tracking kurir dan penerima

### Laporan
- Laporan harian petugas
- Foto dan deskripsi

### Activities
- Aktivitas harian
- Tracking waktu dan foto

### Emergency_Contacts
- Kontak darurat
- Layanan emergency

### Attendance
- Data absensi
- NFC-based check-in/out

### Accident_Reports
- Laporan kecelakaan
- Dokumentasi insiden

## 🔧 API Endpoints

### Authentication
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

## 🚀 Development

### Backend Development

```bash
cd Backend

# Install dependencies
pip install -r requirements.txt

# Run development server
python run.py

# Run tests
python test_api.py

# Initialize database
python init_db.py
```

### Frontend Development

```bash
# Install Flutter dependencies
flutter pub get

# Run in debug mode
flutter run

# Build for production
flutter build apk
flutter build ios
```

## 📚 Documentation

- **Backend API**: http://172.15.1.21:8000/docs
- **Backend ReDoc**: http://172.15.1.21:8000/redoc
- **Backend Setup**: [Backend/SETUP.md](Backend/SETUP.md)
- **Backend README**: [Backend/README.md](Backend/README.md)

## 🔐 Security

### Authentication
- JWT-based authentication
- Password hashing dengan bcrypt
- Session management

### Data Protection
- Input validation dengan Pydantic
- SQL injection protection dengan SQLAlchemy
- CORS configuration

### Production Checklist
- [ ] Ubah SECRET_KEY
- [ ] Set DEBUG=False
- [ ] Konfigurasi CORS dengan domain spesifik
- [ ] Gunakan HTTPS
- [ ] Setup logging
- [ ] Backup database

## 🧪 Testing

### Backend Testing
```bash
cd Backend
python test_api.py
```

### Frontend Testing
```bash
flutter test
```

## 📦 Deployment

### Backend Deployment
- **Docker**: Buat Dockerfile
- **Heroku**: Setup Procfile
- **AWS**: Gunakan EC2 atau Lambda
- **GCP**: Gunakan Cloud Run

### Frontend Deployment
- **Android**: Build APK/AAB
- **iOS**: Build IPA
- **Web**: Build web version

## 👥 Target Users

- **Petugas Keamanan (Security Guard)**
- **Danru (Kepala Regu)**
- **Personel Fasilitas**
- **Admin Site**

## 📞 Support

Untuk bantuan lebih lanjut:
1. Cek dokumentasi API di http://172.15.1.21:8000/docs
2. Lihat log server untuk error details
3. Pastikan semua dependencies terinstall dengan benar

## 📄 License

This project is proprietary software for Perisai Nusantara.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

---

**Perisai Nusantara GuardApp** - Sistem manajemen keamanan dan fasilitas yang terintegrasi
