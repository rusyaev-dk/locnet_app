# Locnet App

Flutter application built from a modular template following Clean Architecture.

**Requirements:** Flutter 3.38.x, Dart 3.9.2+  
**License:** MIT — see [LICENSE](./LICENSE)

## Purpose

This repository provides a baseline for production applications: layered structure, environment configuration, routing, localization, dependency injection, and logging.

## Architecture

- **Presentation:** widgets, screens, BLoC/Cubit  
- **Domain:** entities, business rules, interactors (use cases)  
- **Data:** repositories, APIs, persistence, DTOs  

Interactors reside under `domain/`; BLoC/Cubit state logic resides under `presentation/`.

## Technology stack

| Area | Technology |
|------|------------|
| Routing | go_router |
| State management | flutter_bloc |
| HTTP | dio |
| Storage | flutter_secure_storage, shared_preferences |
| Logging | talker |
| Localization | flutter_localizations, intl |
| Environment | flutter_dotenv |
| Assets | flutter_gen |
| Dependency injection | provider-based custom setup |

## Getting started

```bash
git clone <repository-url>
cd locnet_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

The app entry point is `lib/main.dart`. Environment is selected with `APP_ENV` (`dev`, `stage`, or `prod`). Default if omitted is `stage`.

```bash
flutter run --dart-define=APP_ENV=dev
flutter run --dart-define=APP_ENV=prod
```

Release build for macOS (defaults to `stage` if `APP_ENV` is omitted):

```bash
flutter build macos --release
flutter build macos --release --dart-define=APP_ENV=prod
```

## Configuration

Environment files `.env.*` in the `env/` directory (dev, stage, prod) are loaded via `flutter_dotenv`, according to `APP_ENV` at compile time.

Localization: `flutter gen-l10n`  
Asset code generation: `flutter pub run flutter_gen`

## Debugging

The application includes a debug screen (environment, locale, theme, token utilities, Talker panel, UI kit preview).

Talker logging covers BLoC events, HTTP traffic, exceptions, and application lifecycle events.
