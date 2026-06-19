# 🏗 Gaming Cafe Manager Architecture

## Architecture Overview

Gaming Cafe Manager follows a layered architecture that separates responsibilities into independent modules.

This approach improves:

* Maintainability
* Scalability
* Code readability
* Future backend integration
* Testing and debugging

---

## High-Level Architecture

```text
User Interface
      │
      ▼
Screens
      │
      ▼
Widgets & Services
      │
      ▼
Database Layer
      │
      ▼
SQLite Storage
```

---

## Project Structure

```text
lib/
│
├── main.dart
│
├── data/
│   └── app_data.dart
│
├── database/
│   ├── database_helper.dart
│   ├── device_db.dart
│   ├── history_db.dart
│   ├── queue_db.dart
│   └── session_db.dart
│
├── models/
│   ├── device.dart
│   ├── history_item.dart
│   ├── queue_item.dart
│   └── session.dart
│
├── screens/
│   ├── analytics_page.dart
│   ├── devices_page.dart
│   ├── history_page.dart
│   ├── main_screen.dart
│   ├── queue_page.dart
│   ├── sessions_page.dart
│   └── settings_page.dart
│
├── services/
│   ├── backup_service.dart
│   ├── export_service.dart
│   ├── guest_service.dart
│   ├── pause_service.dart
│   ├── text_scale_service.dart
│   └── theme_service.dart
│
├── theme/
│   └── app_theme.dart
│
├── utils/
│   └── snackbar_helper.dart
│
└── widgets/
    ├── app_header.dart
    ├── device_card.dart
    ├── history_card.dart
    ├── nav_button.dart
    ├── queue_card.dart
    └── session_card.dart
```

Please design and write your own code

without major restructuring of the current codebase.
