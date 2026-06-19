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

---

## Database Layer

Responsible for persistent data storage using SQLite.

### database_helper.dart

* Database initialization
* Schema creation
* Database version management

### device_db.dart

Handles:

* Device creation
* Device updates
* Device deletion
* Device retrieval

### session_db.dart

Handles:

* Active sessions
* Session updates
* Session persistence

### history_db.dart

Stores:

* Completed sessions
* Revenue records
* Historical activity

### queue_db.dart

Handles:

* Waiting customers
* Queue operations
* Queue persistence

---

## Model Layer

Models represent application entities.

### Device

Represents:

* Gaming PCs
* Consoles
* Racing Simulators
* Other gaming equipment

### Session

Represents:

* Active gameplay sessions
* Billing information
* Timing information

### QueueItem

Represents:

* Waiting customers
* Queue metadata

### HistoryItem

Represents:

* Completed session records
* Revenue records

---

## Service Layer

Contains reusable business logic.

### Backup Service

Responsible for:

* Data backups
* Data restoration

### Export Service

Responsible for:

* Revenue exports
* History exports
* Business reports

### Guest Service

Responsible for:

* Guest management
* Temporary customer handling

### Pause Service

Responsible for:

* Session pausing
* Resume handling
* Timer calculations

### Theme Service

Responsible for:

* Theme persistence
* Theme switching

### Text Scale Service

Responsible for:

* Accessibility scaling
* UI text preferences

---

## UI Layer

### Main Screen

Application entry point.

Provides navigation to:

* Devices
* Sessions
* Queue
* Analytics
* History
* Settings

### Devices Page

Manages gaming devices.

### Sessions Page

Manages active gaming sessions.

### Queue Page

Manages waiting customers.

### Analytics Page

Displays revenue and performance metrics.

### History Page

Displays historical records.

### Settings Page

Provides application configuration options.

---

## Widget Layer

Reusable UI components.

### app_header.dart

Application header component.

### device_card.dart

Device display widget.

### session_card.dart

Session display widget.

### queue_card.dart

Queue display widget.

### history_card.dart

History display widget.

### nav_button.dart

Reusable navigation button.

---

## Data Flow

### Starting a Session

```text
User
  │
  ▼
Sessions Page
  │
  ▼
Session Model
  │
  ▼
Session Database
  │
  ▼
SQLite
```

### Ending a Session

```text
Active Session
      │
      ▼
Revenue Calculation
      │
      ▼
History Database
      │
      ▼
Analytics Update
      │
      ▼
UI Refresh
```

---

## Future Expansion

The architecture is intentionally designed to support future migration to:

* FastAPI Backend
* Cloud Synchronization
* Multi-User Support
* Authentication
* Online Booking System
* AI Analytics Engine

without major restructuring of the current codebase.
