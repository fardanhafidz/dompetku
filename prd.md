# **Product Requirement Document (PRD): Dompetku v1.1**

**Status:** Draft / Active  
**Version:** 1.1  
**Project Lead:** User & AI Assistant  
**Stack:** Flutter, Supabase, Bloc, Get\_it, Dio

## **1\. 🚀 Product Overview**

### **Vision**

Dompetku adalah asisten keuangan pribadi yang menghilangkan hambatan psikologis dalam mencatat pengeluaran. Dengan pendekatan **Offline-First**, user bisa mencatat kapan saja tanpa sinyal, dan dengan **AI-Enhanced Input**, user tidak perlu lagi mengetik manual setiap kali menerima struk.

### **Goal MVP v1.1**

1. Menyediakan sistem pencatatan yang reliable (bisa offline).  
2. Mempercepat input data melalui pemindaian struk berbasis OCR.  
3. Memberikan gambaran visual pengeluaran yang intuitif.

## 

## **2\. 🏗️ System Architecture & Data Flow**

Untuk mendukung AI Agent di masa depan, arsitektur data dipisahkan menjadi tiga lapisan:

1. **Input Layer:** Manual Form, AI Receipt Scanner, (Future: AI Agent Chat/Voice).  
2. **Logic Layer (Sync Engine):** Mengelola antrian data lokal, status sinkronisasi, dan validasi data.  
3. **Persistence Layer:** Local Database (Isar/SQLite) sebagai primary source, dan Supabase sebagai remote backup/cloud source.

## 

## **3\. 🎯 Functional Requirements**

### **3.1. Authentication & Security (Core)**

| Feature | Description | Business Rules |
| :---- | :---- | :---- |
| **Email Auth** | Login & Register standar. | Password min. 8 karakter, validasi email format. |
| **Biometric Lock** | Fingerprint/FaceID via local\_auth. | \- Muncul hanya jika diaktifkan di Profile. \- Fallback ke PIN/Password setelah 3x gagal. |
| **Session Mgmt** | Auto-login selama token valid. | Token di-refresh secara background via Supabase Auth. |

### 

### **3.2. Core Transaction Engine (The Foundation)**

Fitur ini menangani bagaimana data disimpan, terlepas dari mana asalnya (Manual atau AI).

* **Offline-First Policy:**  
  * Setiap kali user menekan "Simpan", data wajib masuk ke **Local Database** terlebih dahulu.  
  * Berikan flag sync\_status (Boolean: true/false) atau last\_synced\_at.  
* **Sync Logic:**  
  * Aplikasi mendeteksi koneksi internet (connectivity\_plus).  
  * Jika online, jalankan background proses untuk mengunggah data lokal yang sync\_status \= false ke Supabase.  
  * **Indikator Sinkronisasi:**  
    * ☁️ (Cloud with check): Data tersinkron.  
    * ⏳ (Cloud with arrow/dots): Sedang proses sinkronisasi.  
    * ⚠️ (Cloud with cross): Gagal sinkron (offline).  
* **Conflict Resolution:** Jika ada perbedaan data antara lokal dan server, gunakan kebijakan *Last Write Wins* berdasarkan updated\_at.

### 

### **3.3. Transaction Input: Manual Form**

Ini adalah fondasi input utama. Semua input method lain (AI/Agent) akan bermuara di form ini.

* **Fields:**  
  * amount (Numeric \- Required)  
  * title/merchant (String \- Required)  
  * category\_id (Dropdown \- Required)  
  * transaction\_date (Date Picker \- Default: Today)  
  * notes (String \- Optional)  
  * receipt\_url (String/Path \- Optional)  
  * input\_source (Hidden Field: manual, ocr, ai\_agent) \-\> *Penting untuk tracking data.*

### 

### **3.4. AI Receipt Scanner (Input Enhancement)**

Fitur "pembantu" untuk mengisi Manual Form secara otomatis.

* **Pre-Processing:**  
  * **Image Compression:** Menggunakan library flutter\_image\_compress. Maksimal ukuran file 2MB sebelum diupload ke API OCR atau Supabase Storage.  
  * **Resolution Check:** Jika gambar terlalu blur (deteksi via library sederhana atau prompt user), berikan warning "Gambar buram, hasil mungkin tidak akurat."  
* **OCR Integration (Dio):**  
  * Endpoint: Third-party OCR API (misal: Mindee, Taggun, atau Custom ML).  
  * **Timeout Handling:** Maksimal request adalah **15 detik**.  
  * Jika timeout: Batalkan request, tampilkan Snackbar "Koneksi lambat, silakan isi manual", dan buka Manual Form kosong.  
* **Data Mapping:**  
  * Hasil JSON dari API dipetakan ke field Manual Form.  
  * total\_amount \-\> amount  
  * merchant\_name \-\> title  
  * date \-\> transaction\_date  
  * Aplikasi memberikan badge **"Auto-filled by AI"** pada field yang terisi otomatis.  
* **User Validation:** User **wajib** melakukan review dan menekan tombol "Simpan" secara manual untuk memastikan data AI benar.

### 

### 

### 

### **3.5. Dashboard & Reports**

* **Visualisasi:** Grafik Donut (Kategori) dan Line Chart (Trend mingguan).  
* **Recent Transactions:** List 5-10 transaksi terakhir dengan indikator status sinkronisasi.  
* **Export:** Generate PDF/CSV secara lokal menggunakan data dari Local DB.

## 

## **4\. 🧠 Core Logic & Edge Cases (Detailed)**

### **A. Skenario Offline Lengkap**

1. User di basement (No Signal) menjepret struk.  
2. AI Scanner gagal (karena butuh API).  
3. Aplikasi otomatis lempar ke Manual Form \+ Notifikasi: "Kamu sedang offline, AI Scanner tidak tersedia. Silakan isi manual."  
4. User isi manual \-\> Simpan.  
5. Data masuk Local DB (Status: ⚠️ Offline).  
6. Saat user dapet sinyal di lantai 1, aplikasi otomatis sync ke Supabase (Status berubah jadi ☁️).

### **B. Skenario AI Agent Readiness**

Untuk mempersiapkan AI Agent yang bisa mengklasifikasikan pengeluaran sendiri:

* Tambahkan tabel categories\_metadata yang menyimpan pola kata kunci (misal: "Indomaret" \-\> "Kebutuhan Harian").  
* Simpan raw\_ocr\_text (opsional) di database lokal untuk diolah oleh AI Agent di kemudian hari jika user ingin melakukan audit transaksi lama.

## 

## **5\. 🛠️ Non-Functional Requirements**

1. **Performance:** Loading Dashboard \< 2 detik.  
2. **Reliability:** Data tidak boleh hilang meskipun aplikasi di-*force close* saat proses sinkronisasi.  
3. **UI/UX:** Gunakan Shimmer effect saat AI sedang menganalisa struk untuk mengurangi *perceived wait time*.

## 

## 

## **6\. 📅 Roadmap v1.x**

* **v1.1:** Manual Input, Offline Sync, Dasar AI Scanner.  
* **v1.2:** Category Prediction (AI lokal yang menebak kategori berdasarkan nama merchant).  
* **v1.3:** AI Agent Chat (User ngetik "Makan siang di McD 50rb" \-\> Auto entry).  
* **v1.4:** Budgeting & Limit Alerts.