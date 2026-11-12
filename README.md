![Meme Flutter](hai.jpeg)

# Tugas 4 Praktikum Pemrograman Mobile

Proyek ini merupakan implementasi dari Modul 4 Praktikum Pemrograman Mobile. Terdiri dari dua bagian utama: Backend (RESTful API menggunakan CodeIgniter 4) dan Frontend (Aplikasi Mobile menggunakan Flutter).

## 🚀 Teknologi yang Digunakan

- **Backend:** CodeIgniter 4, PHP
- **Database:** PostgreSQL
- **Frontend:** Flutter, Dart
- **API Testing:** Postman / Bruno

## 📂 Struktur Direktori

Repositori ini memiliki dua direktori utama:

- `toko-api/` : Berisi _source code_ backend CodeIgniter 4 untuk RESTful API.
- `tokokita/` : Berisi _source code_ frontend Flutter untuk antarmuka pengguna.

## ⚙️ Persyaratan Sistem (Prerequisites)

Pastikan sistem Anda sudah terinstal:

- PHP (>= 7.4) beserta ekstensi `pdo_pgsql` dan `pgsql` aktif.
- PostgreSQL Database Server
- Flutter SDK
- Visual Studio Code (disarankan)

## 🛠️ Panduan Instalasi dan Menjalankan Proyek

### 1. Konfigurasi Database (PostgreSQL)

1. Buat database baru di PostgreSQL dengan nama `toko_api`.
2. Jalankan _query_ SQL berikut untuk membuat tabel yang dibutuhkan:

```sql
CREATE table member (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE table member_token (
    id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    auth_key VARCHAR(255) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES member(id) ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE table produk (
    id SERIAL PRIMARY KEY,
    kode_produk VARCHAR(255) NOT NULL,
    nama_produk VARCHAR(255) NOT NULL,
    harga INT NOT NULL
);
```

### 2. Menjalankan Backend (CodeIgniter 4 API)

1. Buka terminal dan arahkan ke direktori backend:
   ```bash
   cd toko-api
   ```
2. Pastikan file konfigurasi database di `app/Config/Database.php` sudah disesuaikan dengan kredensial PostgreSQL Anda (username, password, dan port 5432).
3. Jalankan server lokal CodeIgniter:
   ```bash
   php spark serve
   ```
4. API akan berjalan di `http://localhost:8080`.

### 3. Menjalankan Frontend (Flutter)

1. Buka _tab_ terminal baru dan arahkan ke direktori frontend:
   ```bash
   cd tokokita
   ```
2. Unduh semua _dependencies_:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi (pilih emulator Android, iOS, atau Chrome):
   ```bash
   flutter run
   ```

## 🔗 Dokumentasi Endpoint API

Berikut adalah daftar _endpoint_ yang tersedia di server lokal (`http://localhost:8080`):

| Fitur         |  Method  | Endpoint        | Keterangan                             |
| :------------ | :------: | :-------------- | :------------------------------------- |
| Registrasi    |  `POST`  | `/registrasi`   | Mendaftarkan akun baru                 |
| Login         |  `POST`  | `/login`        | Autentikasi dan mendapatkan token      |
| List Produk   |  `GET`   | `/produk`       | Menampilkan seluruh data produk        |
| Detail Produk |  `GET`   | `/produk/(:id)` | Menampilkan satu produk berdasarkan ID |
| Tambah Produk |  `POST`  | `/produk`       | Menambahkan data produk baru           |
| Ubah Produk   |  `PUT`   | `/produk/(:id)` | Mengubah data produk berdasarkan ID    |
| Hapus Produk  | `DELETE` | `/produk/(:id)` | Menghapus produk berdasarkan ID        |

---

_Dibuat untuk memenuhi Tugas Praktikum Pemrograman Mobile._
