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
├── core/                         # Shared infrastructure and utilities
│   ├── di/                       # Dependency Injection (GetIt)
│   ├── errors/                   # Failures (UI) and Exceptions (Data)
│   ├── network/                  # NetworkInfo & Dio configuration
│   ├── theme/                    # Global AppTheme and color constants
│   └── utils/                    # Sprint 1 Base Utilities (Result, Formatters)
├── routing/                      # GoRouter 'Map' and route definitions
└── src/
    └── features/                 # Independent Vertical Slices
        └── [feature_name]/       # (e.g., transactions, receipt_scanner)
            ├── data/             # The 'How' (Implementation)
            │   ├── datasources/  # Isar (Local) & Remote APIs
            │   ├── models/       # Data mapping (DTOs)
            │   └── repositories/ # Repository implementations
            ├── domain/           # The 'What' (Pure Logic)
            │   ├── entities/     # Pure Dart data objects
            │   ├── repositories/ # Abstract repository contracts
            │   └── usecases/     # Specific business actions
            └── presentation/     # The 'Pixels' (UI)
                ├── bloc/         # Logic/State orchestration
                ├── pages/        # Main feature screens
                └── widgets/      # Feature-specific UI components
```
