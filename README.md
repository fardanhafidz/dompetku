# 💰 Dompetku (Expense Tracker)

A smart, clean, and offline-first personal finance tracker mobile application built with Flutter.

Dompetku helps you track your daily expenses effortlessly, featuring an AI-powered receipt scanner, beautiful insights charts, and seamless cloud synchronization.

---



## 🛠️ Tech Stack & Architecture

This project is built using the **Clean Architecture** pattern to ensure scalability, testability, and separation of concerns.

*   **Framework**: Flutter SDK
*   **State Management**: `flutter_bloc` / `riverpod` (TBD)
*   **Routing**: `go_router` (Nested navigation & deep linking)
*   **Dependency Injection**: `get_it`
*   **Local Database**: `isar` (NoSQL)
*   **Cloud Backend**: `supabase_flutter` (PostgreSQL, Auth)
*   **Data Visualization**: `syncfusion_flutter_charts`
*   **UI Effects**: `shimmer` (Loading skeletons)

---

## 📁 Project Structure

This project follows a 'Feature-First' organization combined with 'Clean Architecture' layers to isolate business logic from infrastructure.

``` 
lib/
├── core/                         # JANTUNG (Infrastructure & Global Logic)
│   ├── database/                 # Local DB Setup (Isar/SQLite)
│   ├── network/                  # Dio & API Configuration
│   ├── sync/                     # THE ENGINE: Sync Manager & Queue Logic
│   ├── error/                    # Failure & Exception classes
│   └── di/                       # Dependency Injection (GetIt)
│
├── shared/                       # TOOLKIT (UI Components & Constants)
│   ├── theme/                    # App Theme & Colors
│   ├── widgets/                  # Reusable UI (Buttons, TextFields)
│   └── constants/                # App Strings & Assets
│
├── features/                     # CAPABILITIES (The "Do" parts)
│   ├── auth/                     # Fitur: Login & Register
│   │   ├── data/                 # Remote Source (Supabase)
│   │   ├── domain/               # Entity & UseCases
│   │   └── presentation/         # Pages & Bloc
│   │
│   ├── transactions/             # Fitur Utama: Management Keuangan
│   │   ├── data/                 # Local & Remote DataSources
│   │   ├── domain/               # Entity: Transaction & Category
│   │   └── presentation/         # Layer UI (Dashboard, History, Input Form)
│   │       ├── bloc/             # Transaction & Summary BLoC
│   │       ├── pages/            # dashboard_page.dart, history_page.dart, form_input_page.dart
│   │       └── widgets/          # Item cards, Chart widgets
│   │
│   ├── receipt_scanner/          # Fitur: AI OCR (Input Helper)
│   │   ├── data/                 # OCR API Service & Image Compression
│   │   ├── domain/               # OCR Result Mapping Logic
│   │   └── presentation/         # Camera & Preview Screen
│   │
│   └── profile/                  # Fitur: User Settings & Security
│       └── presentation/         # Profile & Biometric Toggle
│
├── routing/                      # Navigation Logic (GoRouter)
└── main.dart                     # Entry point (Inisialisasi Core)
```
