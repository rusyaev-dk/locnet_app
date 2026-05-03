# Passcode Feature — Implementation Plan

> Целевое поведение: пользователь может задать числовой PIN в разделе «Конфиденциальность», выбрать таймаут неактивности, после которого приложение блокируется и требует PIN. Блокировка активна **только** при наличии авторизованной сессии.

---

## 1. Структура файлов (новая фича)

```
lib/features/passcode/
├── data/
│   ├── repositories/
│   │   └── local_passcode_repo.dart          # реализация IPasscodeRepo
│   └── passcode_storage_keys.dart            # строковые ключи хранилища
├── domain/
│   ├── models/
│   │   └── passcode_settings.dart            # isEnabled, timeoutMinutes
│   ├── repositories/
│   │   └── i_passcode_repo.dart              # интерфейс
│   └── interactors/
│       └── passcode_interactor.dart          # бизнес-логика
├── presentation/
│   ├── blocs/
│   │   └── passcode_lock_cubit/
│   │       ├── passcode_lock_cubit.dart
│   │       └── passcode_lock_state.dart
│   ├── controllers/
│   │   └── passcode_flow_controller.dart     # ChangeNotifier → GoRouter
│   ├── screens/
│   │   ├── passcode_lock_screen.dart         # ввод PIN при блокировке
│   │   └── passcode_setup_screen.dart        # установка / смена PIN
│   └── widgets/
│       ├── passcode_settings_section.dart    # секция в Privacy settings
│       ├── pin_input_pad.dart                # цифровая клавиатура
│       └── pin_dots.dart                     # индикатор ввода (●●●○○○)
└── passcode.dart                             # barrel export
```

---

## 2. Domain layer

### `PasscodeSettings` — модель настроек

```dart
// lib/features/passcode/domain/models/passcode_settings.dart

class PasscodeSettings {
  const PasscodeSettings({
    required this.isEnabled,
    required this.timeoutMinutes, // 0 = немедленно, null = никогда
  });

  final bool isEnabled;
  final int? timeoutMinutes;

  static const PasscodeSettings disabled = PasscodeSettings(
    isEnabled: false,
    timeoutMinutes: null,
  );
}
```

### `IPasscodeRepo` — интерфейс

```dart
abstract interface class IPasscodeRepo {
  Future<PasscodeSettings> loadSettings();
  Future<void> saveSettings(PasscodeSettings settings);

  /// Сохраняет SHA-256 хеш PIN в SecureStorage.
  Future<void> savePasscodeHash(String pin);

  /// Возвращает true, если SHA-256(pin) совпадает с сохранённым хешем.
  Future<bool> verifyPasscode(String pin);

  /// Удаляет хеш PIN и отключает пасскод.
  Future<void> clearPasscode();

  /// Сохраняет момент фонового ухода (для вычисления таймаута при cold start).
  Future<void> saveLastBackgroundTime(DateTime time);
  Future<DateTime?> loadLastBackgroundTime();
}
```

### `PasscodeInteractor` — бизнес-логика

```dart
class PasscodeInteractor {
  PasscodeInteractor({required IPasscodeRepo passcodeRepo})
    : _repo = passcodeRepo;

  final IPasscodeRepo _repo;

  Future<PasscodeSettings> getSettings() => _repo.loadSettings();

  Future<void> enablePasscode(String pin) async {
    await _repo.savePasscodeHash(pin);
    final current = await _repo.loadSettings();
    await _repo.saveSettings(
      PasscodeSettings(
        isEnabled: true,
        timeoutMinutes: current.timeoutMinutes ?? 1,
      ),
    );
  }

  Future<void> disablePasscode(String pin) async {
    if (!await _repo.verifyPasscode(pin)) {
      throw const PasscodeWrongPinException();
    }
    await _repo.clearPasscode();
  }

  Future<bool> verifyPasscode(String pin) => _repo.verifyPasscode(pin);

  Future<void> updateTimeout(int? minutes) async {
    final current = await _repo.loadSettings();
    await _repo.saveSettings(
      PasscodeSettings(isEnabled: current.isEnabled, timeoutMinutes: minutes),
    );
  }

  /// Проверяет, нужно ли заблокировать приложение
  /// (вызывается при resume).
  Future<bool> shouldLock() async {
    final settings = await _repo.loadSettings();
    if (!settings.isEnabled) return false;

    final timeout = settings.timeoutMinutes;
    if (timeout == null) return false;    // "никогда"
    if (timeout == 0) return true;        // "немедленно"

    final lastBg = await _repo.loadLastBackgroundTime();
    if (lastBg == null) return false;

    final elapsed = DateTime.now().difference(lastBg).inMinutes;
    return elapsed >= timeout;
  }
}
```

---

## 3. Data layer

### `PasscodeStorageKeys`

```dart
abstract final class PasscodeStorageKeys {
  // SecureStorage
  static const String passcodeHash = 'passcode_hash';

  // LocalKeyValueStorage
  static const String isEnabled      = 'passcode_is_enabled';
  static const String timeoutMinutes = 'passcode_timeout_minutes';
  static const String lastBackgroundMs = 'passcode_last_background_ms';
}
```

### `LocalPasscodeRepo`

```dart
class LocalPasscodeRepo implements IPasscodeRepo {
  const LocalPasscodeRepo({
    required IKeyValueStorage secureStorage,
    required IKeyValueStorage localStorage,
  })  : _secure = secureStorage,
        _local = localStorage;

  final IKeyValueStorage _secure; // flutter_secure_storage
  final IKeyValueStorage _local;  // shared_preferences

  @override
  Future<void> savePasscodeHash(String pin) async {
    final hash = _sha256(pin);
    await _secure.write<String>(key: PasscodeStorageKeys.passcodeHash, value: hash);
  }

  @override
  Future<bool> verifyPasscode(String pin) async {
    final stored = await _secure.read<String>(key: PasscodeStorageKeys.passcodeHash);
    if (stored == null) return false;
    return _sha256(pin) == stored;
  }

  // ... остальные методы аналогично

  String _sha256(String pin) {
    // пакет crypto: sha256.convert(utf8.encode(pin)).toString()
    return sha256.convert(utf8.encode(pin)).toString();
  }
}
```

> **Зависимость:** добавить `crypto: ^3.0.6` в `pubspec.yaml`.
> PIN хранится только в виде хеша — даже при компрометации SecureStorage оригинал недоступен.

---

## 4. State management — `PasscodeLockCubit`

### Состояния

```dart
sealed class PasscodeLockState {}

/// Пасскод не настроен или не нужен при текущей сессии.
final class PasscodeLockDisabledState extends PasscodeLockState {}

/// Приложение разблокировано (PIN введён или таймаут не истёк).
final class PasscodeLockUnlockedState extends PasscodeLockState {}

/// Приложение заблокировано — требует PIN.
final class PasscodeLockLockedState extends PasscodeLockState {}

/// Неверный PIN (отображается индикатор ошибки на lock screen).
final class PasscodeLockWrongPinState extends PasscodeLockState {}
```

### Cubit

```dart
class PasscodeLockCubit extends Cubit<PasscodeLockState> {
  PasscodeLockCubit({required PasscodeInteractor passcodeInteractor})
    : _interactor = passcodeInteractor,
      super(PasscodeLockDisabledState());

  final PasscodeInteractor _interactor;

  /// Вызывается при старте приложения / восстановлении сессии.
  Future<void> initialize() async {
    final settings = await _interactor.getSettings();
    if (!settings.isEnabled) {
      emit(PasscodeLockDisabledState());
      return;
    }
    // При восстановлении сессии — сразу проверяем таймаут
    final shouldLock = await _interactor.shouldLock();
    emit(shouldLock ? PasscodeLockLockedState() : PasscodeLockUnlockedState());
  }

  /// Вызывается, когда приложение уходит в фон.
  Future<void> onAppPaused() async {
    final settings = await _interactor.getSettings();
    if (!settings.isEnabled) return;
    await _interactor.saveLastBackgroundTime(DateTime.now());
    if (settings.timeoutMinutes == 0) {
      emit(PasscodeLockLockedState());
    }
  }

  /// Вызывается, когда приложение выходит на передний план.
  Future<void> onAppResumed() async {
    if (state is PasscodeLockDisabledState) return;
    final shouldLock = await _interactor.shouldLock();
    if (shouldLock) emit(PasscodeLockLockedState());
  }

  /// Попытка разблокировки.
  Future<void> unlock(String pin) async {
    final correct = await _interactor.verifyPasscode(pin);
    emit(correct ? PasscodeLockUnlockedState() : PasscodeLockWrongPinState());
    // Сбрасываем WrongPin через ~600 мс для повторного ввода
    if (!correct) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      emit(PasscodeLockLockedState());
    }
  }

  /// Пользователь включает пасскод через настройки.
  Future<void> enablePasscode(String pin) async {
    await _interactor.enablePasscode(pin);
    emit(PasscodeLockUnlockedState());
  }

  /// Пользователь отключает пасскод через настройки.
  Future<void> disablePasscode(String pin) async {
    await _interactor.disablePasscode(pin);
    emit(PasscodeLockDisabledState());
  }

  /// Сессия уничтожена — блокировка не нужна.
  void onSessionCleared() => emit(PasscodeLockDisabledState());
}
```

---

## 5. Интеграция с роутером — `PasscodeFlowController`

```dart
/// ChangeNotifier, который GoRouter слушает через refreshListenable.
final class PasscodeFlowController extends ChangeNotifier {
  PasscodeFlowController({required PasscodeLockCubit cubit}) {
    _isLocked = cubit.state is PasscodeLockLockedState;
    _subscription = cubit.stream.listen((state) {
      final locked = state is PasscodeLockLockedState;
      if (locked != _isLocked) {
        _isLocked = locked;
        notifyListeners();
      }
    });
  }

  late bool _isLocked;
  late final StreamSubscription<PasscodeLockState> _subscription;

  bool get isLocked => _isLocked;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
```

### Изменения в `AppRouter.createRouter`

**1. Добавить параметр и `refreshListenable`:**
```dart
static GoRouter createRouter({
  required AuthFlowController authFlowController,
  required PasscodeFlowController passcodeFlowController, // ← новый
  ...
}) {
  return GoRouter(
    refreshListenable: Listenable.merge([
      authFlowController,
      passcodeFlowController,         // ← объединяем оба listenable
    ]),
    redirect: (context, state) {
      final authStatus = authFlowController.status;
      final isLocked   = passcodeFlowController.isLocked;
      final location   = state.uri.path;

      // --- существующая auth-логика ---
      // ... (не меняется)

      // --- новая passcode-логика ---
      // Блокируем только когда авторизованы и не на экране пасскода
      if (authStatus == AuthFlowStatus.authenticated &&
          isLocked &&
          location != AppRoutes.passcodeLock) {
        return AppRoutes.passcodeLock;
      }

      // Если уже разблокированы — уходим с экрана пасскода
      if (location == AppRoutes.passcodeLock && !isLocked) {
        return AppRoutes.conversations;
      }

      return null;
    },
    routes: [
      // ... существующие маршруты ...

      GoRoute(
        path: '/passcode-lock',
        name: 'passcodeLock',
        pageBuilder: buildFadePage((context, state) {
          return const PasscodeLockScreen();
        }),
      ),
    ],
  );
}
```

**2. Добавить `/passcode-lock` в `AppRoutes`:**
```dart
abstract final class AppRoutes {
  static const String passcodeLock = '/passcode-lock';
  // ... остальные
}
```

---

## 6. App Lifecycle — отслеживание фона

`LocnetApp` — уже StatefulWidget. Добавляем `WidgetsBindingObserver`:

```dart
class _LocnetAppState extends State<LocnetApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cubit = context.read<PasscodeLockCubit>();
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:   // для desktop/web
        cubit.onAppPaused();
      case AppLifecycleState.resumed:
        cubit.onAppResumed();
      default:
        break;
    }
  }
  // ...
}
```

> Важно: `context.read<PasscodeLockCubit>()` требует, чтобы `PasscodeLockCubit` был добавлен в `BlocProvider` **выше** `LocnetApp` — т.е. в `AppProvidersWrapper` (см. п. 8).

---

## 7. Сброс блокировки при logout

В `AuthFlowController._handleUnauthorizedEvent()` (или в подписке на `AuthCubit` в `PasscodeLockCubit`) нужно сбросить состояние:

```dart
// В PasscodeLockCubit: добавить подписку на AuthCubit
_authSubscription = authCubit.stream.listen((authState) {
  if (authState is AuthUnauthenticatedState ||
      authState is AuthFailureState) {
    onSessionCleared(); // emit(PasscodeLockDisabledState())
  }
});
```

Это гарантирует, что экран пасскода не показывается после логаута.

---

## 8. Dependency Injection — изменения в `AppProvidersWrapper`

```dart
// В RepositoryProvider секции добавить:
RepositoryProvider<IPasscodeRepo>(
  create: (context) {
    final bool useMacOsFallback =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
    final secureStorage = useMacOsFallback
        ? appScope.storageAggregator.localKeyValueStorage
        : appScope.storageAggregator.secureStorage;
    return LocalPasscodeRepo(
      secureStorage: secureStorage,
      localStorage: appScope.storageAggregator.localKeyValueStorage,
    );
  },
),
RepositoryProvider<PasscodeInteractor>(
  create: (context) => PasscodeInteractor(
    passcodeRepo: context.read<IPasscodeRepo>(),
  ),
),

// В _BlocProviders добавить:
BlocProvider(
  lazy: false,
  create: (context) => PasscodeLockCubit(
    passcodeInteractor: context.read<PasscodeInteractor>(),
    authCubit: context.read<AuthCubit>(),  // для автосброса при logout
  )..initialize(),
),
```

В `LocnetApp.build` / `createRouter` добавить создание `PasscodeFlowController`:
```dart
// В том же месте, где создаётся authFlowController:
final passcodeFlowController = PasscodeFlowController(
  cubit: context.read<PasscodeLockCubit>(),
);

final router = AppRouter.createRouter(
  authFlowController: authFlowController,
  passcodeFlowController: passcodeFlowController,
  ...
);
```

---

## 9. UI — экраны и виджеты

### `PasscodeLockScreen`

- Полноэкранный оверлей (без ShellRoute — нет панели навигации)
- Показывает: имя пользователя / аватар (из `AuthCubit.state`), `PinDots`, `PinInputPad`
- При `PasscodeLockWrongPinState` — тряска (shake animation) точек и сброс через 600 мс
- Кнопка «Выйти из аккаунта» (вызывает `AuthCubit.logOut()`)

### `PasscodeSetupScreen`

- Два шага: «Введите PIN» → «Повторите PIN»
- При совпадении — вызывает `PasscodeLockCubit.enablePasscode(pin)`
- Открывается модально через `showDialog` или как отдельный route `/passcode-setup`

### `PasscodeSettingsSection` — в `PrivacySettingsContent`

Добавить **выше** `SessionInfo`:

```dart
// В PrivacySettingsContent.build, перед SessionInfo:
PasscodeSettingsSection(),
const SizedBox(height: 20),
```

Содержимое секции:
```
PASSCODE
┌─────────────────────────────────────────────┐
│ App Lock                    [Switch: ON/OFF] │
├─────────────────────────────────────────────┤
│ Lock after                        1 minute › │  ← только если enabled
├─────────────────────────────────────────────┤
│ Change Passcode                           › │  ← только если enabled
└─────────────────────────────────────────────┘
```

«Lock after» — открывает `BottomSheet` или `AlertDialog` с вариантами:
- Немедленно
- 1 минута
- 5 минут
- 15 минут
- 30 минут
- 1 час
- Никогда (пасскод только при открытии приложения)

---

## 10. Порядок реализации (по шагам)

| Шаг | Что делать | Файлы |
|-----|-----------|-------|
| 1 | Добавить `crypto` в `pubspec.yaml`, создать domain layer | `passcode_settings.dart`, `i_passcode_repo.dart`, `passcode_interactor.dart` |
| 2 | Реализовать `LocalPasscodeRepo` | `local_passcode_repo.dart`, `passcode_storage_keys.dart` |
| 3 | Создать `PasscodeLockCubit` + состояния | `passcode_lock_cubit.dart`, `passcode_lock_state.dart` |
| 4 | Создать `PasscodeFlowController` | `passcode_flow_controller.dart` |
| 5 | Зарегистрировать в DI (`AppProvidersWrapper`) | `app_providers_wrapper.dart` |
| 6 | Интегрировать в роутер | `router.dart`, `app_routes.dart` |
| 7 | Добавить `WidgetsBindingObserver` в `LocnetApp` | `locnet_app.dart` |
| 8 | Создать `PinDots` + `PinInputPad` | общие виджеты |
| 9 | Создать `PasscodeLockScreen` | `passcode_lock_screen.dart` |
| 10 | Создать `PasscodeSetupScreen` | `passcode_setup_screen.dart` |
| 11 | Создать `PasscodeSettingsSection`, встроить в Privacy | `passcode_settings_section.dart`, `privacy_settings_content.dart` |
| 12 | Добавить локализацию (ARB) | `app_en.arb`, `app_ru.arb` |
| 13 | Тестирование edge cases (см. ниже) | — |

---

## 11. Edge cases

- **Биометрика (опционально):** можно добавить `local_auth` пакет — кнопка «Face ID / Touch ID» на `PasscodeLockScreen` как быстрый вариант, вместо ввода PIN
- **macOS:** на macOS SecureStorage заменяется на LocalStorage (уже есть паттерн в `app_providers_wrapper.dart`) — хеш PIN будет храниться менее защищённо, можно добавить предупреждение
- **Смена PIN:** открывает `PasscodeSetupScreen` в режиме «смены» — сначала запрашивает старый PIN, затем дважды новый
- **Принудительная блокировка:** при получении `UnauthorizedEvent` → `onSessionCleared()` чтобы экран блокировки не мелькнул после logout
- **Первый запуск после logout:** при новой авторизации `initialize()` проверяет `isEnabled` — если PIN не задан, остаётся `Disabled`
- **Неверный PIN 5 раз подряд:** опционально — временная блокировка на 30 сек с обратным отсчётом

---

## 12. Ключевой принцип: где проверяется блокировка

```
Запуск приложения
       │
       ▼
  tryRestoreSession()   ──успех──►  PasscodeLockCubit.initialize()
       │                                     │
       │                          isEnabled? ├─ нет  → Disabled (норм)
       │                                     │
       │                          shouldLock?├─ нет  → Unlocked (норм)
       │                                     │
       │                                     └─ да   → Locked → /passcode-lock
       │
  ──неудача──► AuthUnauthenticated → /login   (пасскод не нужен)

Приложение в фоне ──► onAppPaused() → сохраняет timestamp
Приложение в активно ──► onAppResumed() → shouldLock() → Lock если нужно
```

Блокировка срабатывает **только** при `AuthFlowStatus.authenticated`. Роутер не пустит на `/passcode-lock` без авторизованной сессии.
