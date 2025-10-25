<div align="center">

# 🚀 Flutter App Template

![Flutter](https://img.shields.io/badge/Flutter-3.32.0+-02569B?style=for-the-badge\&logo=flutter\&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.8.0+-0175C2?style=for-the-badge\&logo=dart\&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

**A scalable Flutter app starter template based on Clean Architecture with modular feature organization.**
</div>

## 📘 About

This template provides a solid foundation for production-ready Flutter apps with:

* 🧱 Modular architecture
* 🧪 Built-in environment support
* 🌐 Declarative routing (`go_router`)
* 🔐 Secure and shared storage
* 🔄 `flutter_bloc` state management
* 📦 Ready-to-use DI and logging
* 🌍 Localization support

## 🧱 Architecture Overview

The template follows Clean Architecture principles with a specific adjustment:

> 🟡 **Interactors (use cases)** live in the `domain/` layer
> 🟡 **BLoC/Cubit logic** lives in the `presentation/` layer

```
🔐 PRESENTATION
Widgets, Screens, BLoC, Cubit

🔐 DOMAIN
Business Logic, Entities, Interactors

🔐 DATA
Repositories, APIs, Storage, DTOs
```

## 🌟 Goals

* 🏁 Kickstart new apps in minutes
* 🧱 Encourage consistency and scalability
* 🧪 Enable testability and clean separation
* 👥 Fit team-based and long-term projects

## 💠 Tech Stack

| Area             | Package                         |
| ---------------- | ------------------------------- |
| Routing          | `go_router`                     |
| State Management | `flutter_bloc`                  |
| HTTP             | `dio`                           |
| Secure Storage   | `flutter_secure_storage`        |
| Shared Storage   | `shared_preferences`            |
| Logging          | `talker`                        |
| Localization     | `flutter_localizations`, `intl` |
| Env Variables    | `flutter_dotenv`                |
| Asset Generation | `flutter_gen`                   |
| DI               | `provider`-based custom DI      |

## 🚀 Quick Start

### 1. Clone and install dependencies

```bash
git clone https://github.com/your-org/locnet_app.git
cd locnet_app
flutter pub get
```

### 2. Generate code

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run the app

```bash
flutter run --target lib/targets/dev.dart
```

Other environments:

```bash
flutter run --target lib/targets/stage.dart
flutter run --target lib/targets/prod.dart
```

## ⚙️ Configuration

### 📁 Environments

`.env` files stored in `/env`:

* `.env.dev` — development
* `.env.stage` — staging
* `.env.prod` — production

Loaded via `flutter_dotenv`.

### 🌍 Localization

```bash
flutter gen-l10n
```

### 🎨 Assets

```bash
flutter pub run flutter_gen
```

## 🧪 Debugging

### 🔛 Debug screen

Includes:

* Environment info
* Locale switcher
* Theme toggles
* Token tools
* Talker logging panel
* UI kit preview

Accessible via in-app debug button.

### 📊 Logging with Talker

Tracks:

* Bloc events and transitions
* HTTP requests/responses
* Exceptions and errors
* App lifecycle logs

## 📄 License

This project is licensed under the MIT License.
See the [LICENSE](./LICENSE) file for details.

---

Built with ❤️ for scalable Flutter development.
