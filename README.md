# UTS Mobile Programming - Aplikasi Top Up Game

Aplikasi Flutter sederhana yang dibuat untuk Ujian Tengah Semester (UTS) mata kuliah Mobile Programming. Aplikasi ini berfungsi sebagai platform simulasi untuk melihat daftar game dan halaman top up.

## 📖 Deskripsi Aplikasi

Aplikasi ini adalah sebuah prototipe mobile untuk layanan top up game. Pengguna dapat melihat daftar game yang tersedia, memfilter berdasarkan kategori, melihat detail singkat, dan mensimulasikan proses menuju halaman pengisian data top up.

**Tema:** Layanan Top Up Game

## Fitur Utama

* **Beranda (Home):**
    * Menampilkan *search bar* (fungsi pencarian belum aktif).
    * Menampilkan daftar game populer dalam *list* horizontal.
    * Menampilkan tombol kategori game (Mobile, PC, Consoles, Voucher, dll.).
    * Menampilkan daftar game unggulan dalam *list* vertikal.
* **Daftar Game (List):**
    * Menampilkan daftar game berdasarkan kategori yang dipilih dari beranda.
    * Setiap item menampilkan *thumbnail*, judul, dan genre game.
* **Detail Singkat Game (Detail):**
    * Menampilkan *banner* game, judul, tombol "Top Up", info singkat (genre, platform, publisher, tanggal rilis), dan *minimum system requirements*.
* **Halaman Top Up (Top Up):**
    * Menampilkan *banner* game.
    * Menyediakan form untuk memasukkan ID Game, Jumlah Diamond/Item, dan Email.
* **Navigasi:** Menggunakan *Named Routes* untuk perpindahan antar halaman.
* **Data:** Menggunakan data *dummy* yang didefinisikan di dalam kode (*ViewModel*).

## 🚀 Cara Menjalankan Aplikasi

1.  **Clone repositori ini:**
    ```bash
    git clone [https://github.com/Jekizunn/TopUPPuts](https://github.com/Jekizunn/TopUPPuts)
    cd TopUPPuts
    ```
2.  **Pastikan Flutter SDK terpasang.** Jika belum, ikuti panduan instalasi di [flutter.dev](https://flutter.dev).
3.  **Dapatkan dependensi:**
    ```bash
    flutter pub get
    ```
4.  **Jalankan aplikasi:**
    Hubungkan perangkat (emulator atau fisik) lalu jalankan perintah:
    ```bash
    flutter run
    ```

## 🖼️ Struktur Halaman (Navigasi)

* **`/` (Initial Route):** `HomePage` - Menampilkan beranda aplikasi.
* **`/list`:** `GameListPage` - Menampilkan daftar game berdasarkan kategori (menerima argumen `String category`).
* **`/detail`:** `ShortDetailPage` - Menampilkan detail singkat game (menerima argumen `int gameId`).
* **`/topup`:** `TopUpPage` - Menampilkan form input top up (menerima argumen `int gameId`).

## 🛠️ Teknologi yang Digunakan

* **Framework:** Flutter
* **Bahasa:** Dart
* **Manajemen Data:** Data Dummy (List<Map> / Class Model)
* **Navigasi:** Named Routes (Navigator 2.0)

---
