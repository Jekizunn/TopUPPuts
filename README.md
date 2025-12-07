# 🎮 Top Upp — Aplikasi Top Up Game (UAS Project)

**Top Upp** adalah aplikasi mobile berbasis **Flutter** untuk simulasi pembelian item/diamond pada game. Proyek ini dikembangkan sebagai **Final Project** mata kuliah *Mobile Programming*.

Aplikasi ini menggunakan arsitektur **Hybrid API**:

* **API Publik (FreeToGame):** Menyediakan katalog game real-time.
* **API Lokal (PHP & MySQL):** Menangani transaksi dan riwayat pembelian.

---

## ✨ Fitur Utama

* Jelajah game secara real-time.
* Pencarian & filter genre.
* Detail game lengkap (gambar, platform, deskripsi).
* Simulasi top up (Create).
* Riwayat transaksi (Read).
* Validasi input.
* Feedback visual (loading, snackbar, struk pembelian).

---

## 🛠 Teknologi yang Digunakan

| Layer        | Teknologi      |
| ------------ | -------------- |
| Frontend     | Flutter (Dart) |
| Backend      | PHP Native     |
| Database     | MySQL          |
| HTTP Client  | `http` package |
| External API | FreeToGame API |

---

# 📁 Struktur Folder

```
TopUpp/
├── lib/
│   ├── main.dart
│   ├── config.dart
│   ├── pages/
│   │   ├── home_page.dart
│   │   ├── detail_page.dart
│   │   ├── topup_page.dart
│   │   ├── history_page.dart
│   │   └── success_page.dart
│   └── widgets/
│       └── ...
│
├── topup_api/ (Server Lokal)
│   ├── koneksi.php
│   ├── submit.php
│   └── history.php
│
├── pubspec.yaml
└── README.md
```

---

# ⚙️ Instalasi & Setup

## 1. Setup Server & Database

### Buat database:

```sql
CREATE DATABASE db_topup;

USE db_topup;

CREATE TABLE transaksi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    game_id VARCHAR(50) NOT NULL,
    game_title VARCHAR(100) NOT NULL,
    jumlah_diamond INT NOT NULL,
    email VARCHAR(100) NOT NULL,
    tanggal DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### Letakkan file API lokal:

Buat folder:

* `htdocs/topup_api/` (XAMPP), atau
* `www/topup_api/` (Laragon)

Isi file:

```
koneksi.php
submit.php
history.php
```

Pastikan `koneksi.php` terhubung dengan database `db_topup`.

---

## 2. Konfigurasi IP Laptop

1. Buka CMD:

   ```
   ipconfig
   ```
2. Ambil **IPv4 Address** (contoh: `192.168.1.10`)
3. Di Flutter:

```dart
const String ipLaptop = '192.168.1.10'; 
```

> Wajib: HP/Emulator harus satu jaringan WiFi dengan laptop.

---

## 3. Menjalankan Flutter

```bash
flutter pub get
flutter run
```

---

# 🔗 Endpoint API

| Method | Endpoint                 | Deskripsi                   | Sumber         |
| ------ | ------------------------ | --------------------------- | -------------- |
| GET    | `/api/games`             | Ambil daftar game real-time | FreeToGame API |
| POST   | `/topup_api/submit.php`  | Simpan transaksi baru       | Server Lokal   |
| GET    | `/topup_api/history.php` | Riwayat transaksi by email  | Server Lokal   |

---

# 📌 Contoh Request API

### 1. GET Game List (FreeToGame)

```bash
GET https://www.freetogame.com/api/games
```

### 2. POST Transaksi

```bash
POST http://<IP_LAPTOP>/topup_api/submit.php

Body (x-www-form-urlencoded):
game_id=123
game_title=Genshin Impact
jumlah_diamond=500
email=user@email.com
```

### 3. GET Riwayat Transaksi

```bash
GET http://<IP_LAPTOP>/topup_api/history.php?email=user@email.com
```

---

# 👤 Author

**Nama:** *Moch. Dzaky Sunnii Kautsar*
**NIM:** *230605110053*

---
