# Transactions Feature - Handoff Notes

Halo! 👋 Dokumen ini dibikin biar kita satu frekuensi pas lo mulai ngerjain **Data Layer** dan **Presentation (UI) Layer** buat fitur Transaksi.

Secara mekanik, Domain Layer (Entities & UseCases) udah sangat *self-explanatory* (kita pake standar `dartz` `Either` dan `equatable`). Tapi, ada keputusan bisnis penting dari hasil sinkronisasi PRD biar MVP aplikasi kita bisa jalan mulus:

## 1. Perbedaan UI Mockup vs Domain Layer (PENTING!)
Kalau lo liat *screenshot* UI, ada beberapa field di `Transaction Detail` yang **sengaja kita drop** di `TransactionEntity` buat rilis MVP (v1.1):
*   ❌ `items` (rincian barang per struk): Bikin ribet DB relasional dan UI form kepanjangan. Kita fokus ke "Total Pengeluaran" aja (`amount`).
*   ❌ `paymentMethod`: Nggak essential buat MVP Expense Tracker dasar.
*   ❌ `status`: Semua transaksi dianggap "Completed".

Jadi, patokan data lo **wajib** ngikutin `TransactionEntity`, jangan ngikutin halusinasi UI Mockup yang terlalu *advanced*.

## 2. Offline-First Engine (Sync Logic)
Fitur transaksi ini wajib bisa jalan tanpa internet. Kuncinya ada di 3 field ini di `TransactionEntity`:
*   `createdAt` & `updatedAt`: Buat tau *Last Write Wins* kalau ada konflik saat sinkronisasi.
*   `syncStatus` (Boolean): 
    * `false`: Data baru masuk Local DB (Isar) dan belum dikirm ke Supabase.
    * `true`: Data udah bersemayam dengan tenang di Supabase.

**Tugas di Data Layer:** `SyncTransactionsUseCase` nantinya cuma bakal nyuruh repo buat ngambil data lokal yang `syncStatus == false`, terus nembak API Supabase (Insert/Update). Kalo sukses, set true di lokal.

## 3. Peta UseCase -> UI Map
Biar lo nggak bingung mau manggil UseCase yang mana di BLoC:
*   **Form Tambah Transaksi**: Panggil `GetCategoriesUseCase` (buat isi dropdown). Pas disubmit, panggil `AddTransactionUseCase`.
*   **Filter/List Transaksi**: Panggil `GetTransactionsUseCase` (bisa passing filter `categoryId` atau rentang tanggal).
*   **Donut Chart/Grafik Insights**: Panggil `GetTransactionSummaryUseCase` (ini bakal return `Map<String, double>` yang isinya total duit per kategori, tinggal lo *passing* ke library chart).
*   **AI Scanner (OCR)**: Panggil `ScanReceiptUseCase`. Return-nya `Map` mentah, tolong di-*fill* ke UI Form, biarkan user yang klik Simpan.

Semangat ngerjain Data Layer & UI-nya! 🚀🔥
