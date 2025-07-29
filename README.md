
# Vendor Management System

A sample cross-platform **Vendor Management System** built in **Flutter** to showcase expertise in:

- **Clean Architecture**
- **Riverpod (state management)**
- **Provider Overrides for Testing**
- **Modular and Scalable Code Structure**
- **Offline Support (Hive/SharedPreferences)**
- **API Integration (Chopper or Dio)**
- **Custom Widgets & UI Components**
- **Unit & Widget Testing**

## Project Overview

This application demonstrates core functionalities typically required in a vendor-based business solution:

- Vendor listing with search and filter
- Detailed vendor profile with services, contact info, and location
- Add/update/delete vendor records
- Local persistence for offline mode
- Test coverage for core business logic

The aim is to demonstrate production-level Flutter code organization, scalable architecture patterns, and best practices suitable for real-world app development.

## Features

- **Home Screen**: Displays all vendors with pagination or lazy loading
- **Search/Filter**: Search vendors by name or category
- **Vendor Details**: Full vendor profile with dynamic UI
- **Add/Edit Vendor**: Validated forms for input
- **API Integration**: Configurable base URLs using Chopper or Dio
- **Local Storage**: Hive/SharedPreferences for persistence
- **Dependency Injection**: Powered by `riverpod` and `get_it`
- **Testing**: Unit and widget tests with mock providers

## Tech Stack

| Layer            | Technology Used           |
|------------------|----------------------------|
| UI               | Flutter (Material)         |
| State Management | Riverpod + ProviderScope   |
| Architecture     | Clean Architecture         |
| Networking       | Chopper / Dio              |
| Storage          | Hive / SharedPreferences   |
| Testing          | Mockito, flutter_test      |

## Folder Structure (Clean Architecture)

```
lib/
├── core/
├── features/
│   └── vendor/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
├── main.dart
```

## Getting Started

1. Clone the repo  
   ```bash
   git clone https://github.com/anjum-chauhan/CRM.git
   ```

2. Install dependencies  
   ```bash
   flutter pub get
   ```

3. Run the app  
   ```bash
   flutter run
   ```

## Running Tests

```bash
flutter test
```

## About the Author

This project is developed and maintained by **Anjum Chauhan** to demonstrate Flutter development proficiency. The goal is to deliver scalable, testable, and clean Flutter applications suitable for enterprise-level use cases.
