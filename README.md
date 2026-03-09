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
│   ├── constants/                # App-wide constants
│   ├── di/                       # Dependency Injection (GetIt)
│   ├── entities/                 # Global Entities (UserEntity)
│   ├── env/                      # Environment Variables (Envied)
│   ├── errors/                   # Failure & Exception classes
│   ├── models/                   # Global Models (UserModel)
│   ├── network/                  # Dio & API Configuration
│   ├── sync/                     # THE ENGINE: Sync Manager & Queue Logic
│   └── utils/                    # Helper / Utility classes
│
├── shared/                       # TOOLKIT (UI Components & Constants)
│   ├── theme/                    # App Theme & Colors
│   └── widgets/                  # Reusable UI (Buttons, TextFields)
│
├── features/                     # CAPABILITIES (The "Do" parts)
│   ├── auth/                     # Fitur: Login, Register & OTP
│   │   ├── data/                 # DataSources, Models, Repository Impl
│   │   ├── domain/               # Entities, UseCases, Repository Contract
│   │   └── presentation/         # Pages, Bloc, Widgets
│   │
│   ├── transactions/             # Fitur Utama: Management Keuangan
│   │   ├── data/                 # Local & Remote DataSources (TBD)
│   │   ├── domain/               # Entity: Transaction & Category (TBD)
│   │   └── presentation/         # Layer UI
│   │       ├── bloc/             # Transaction & Summary BLoC (TBD)
│   │       ├── pages/            # dashboard_page, history_page, insights_page, form_input_page
│   │       └── widgets/          # Item cards, Chart widgets (TBD)
│   │
│   ├── receipt_scanner/          # Fitur: AI OCR (Input Helper) (TBD)
│   │
│   └── profile/                  # Fitur: User Settings & Security
│       └── presentation/         # Profile & Biometric Toggle
│
├── routing/                      # Navigation Logic (GoRouter)
│   ├── app_router.dart           # Route definitions
│   └── main_wrapper.dart         # Bottom Navigation wrapper
└── main.dart                     # Entry point (Inisialisasi Core)
```
