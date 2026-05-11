# UX Plan: Бесшовный draft без отдельного роута

## Диагноз

### Текущий флоу (проблема)

```
Unified Search → тап по person
  → router.go('/conversations/draft/:companionId')
  → ConversationsPanel ребилдится
  → PrivateConversationBloc создаётся, эмитит DraftState

Пользователь отправляет первое сообщение
  → POST getOrCreateByCompanion  
  → Bloc эмитит LoadedState(pendingNavigationConversationId: newId)
  → BlocListener → router.go('/conversations/:newId')
  → ConversationsPanel снова ребилдится с новым key на wrapper
  → НОВЫЙ BLoC → StartedEvent → LoadingState → shimmer → LoadedState
```

**Два симптома:**

1. Draft существует как отдельный роут — это navigation concern, а не business state.
2. При переходе из draft в реальную переписку виджет-дерево пересоздаётся: shimmer, двойной rebuild.

### Принцип решения

> `PrivateConversationDraftState` уже есть в BLoC. Draft — это **состояние блока**, а не маршрут. Роут `/conversations/draft/:id` — лишний.

Стабильный ключ (`companionId`) на `PrivateConversationScreenWrapper` позволяет держать виджет и BLoC живыми при переходе draft → реальная переписка. Никакого shimmer.

---

## Архитектурные слои и изменения

### Слой Data / Domain — без изменений

Бизнес-логика (`PrivateConversationInteractor`, `getOrCreateByCompanion`, repo, interactor) не трогается. Clean Architecture соблюдена.

---

### Слой Presentation — `UnifiedSearchBloc`

**Проблема:** Сервер возвращает `users` и `conversations` раздельно. Если пользователь уже является компаньоном в существующей переписке, в results появляются оба. UI должен показать плитку существующей переписки вместо плитки нового пользователя.

**Решение:** Добавить шаг `_resolvePeopleItems` внутри `_onLoad` и `_onLoadMore`.

#### Новая presentation-модель

```
lib/features/conversations_list/subfeatures/unified_search/
  presentation/models/unified_search_person_item.dart
```

```dart
/// View-model для секции "Люди" в unified search.
/// Два варианта: пользователь без переписки (→ draft) и с переписками (→ навигация).
sealed class UnifiedSearchPersonItem extends Equatable {
  const UnifiedSearchPersonItem({required this.user});
  final User user;
}

/// Переписки с этим пользователем нет. Тап → открыть draft.
final class UnifiedSearchNewPersonItem extends UnifiedSearchPersonItem {
  const UnifiedSearchNewPersonItem({required super.user});

  @override
  List<Object?> get props => [user];
}

/// Переписка уже существует. Тап → навигация к ней.
final class UnifiedSearchExistingPersonItem extends UnifiedSearchPersonItem {
  const UnifiedSearchExistingPersonItem({
    required super.user,
    required this.conversation,
  });

  final UnifiedSearchConversation conversation;

  @override
  List<Object?> get props => [user, conversation];
}
```

#### `UnifiedSearchLoadedState` — добавить поле

```dart
final class UnifiedSearchLoadedState extends UnifiedSearchState {
  const UnifiedSearchLoadedState({
    // ... существующие поля ...
    required this.peopleItems, // новое
  });

  /// Список людей с разрешённым статусом (новый / уже есть переписка).
  final List<UnifiedSearchPersonItem> peopleItems;
}
```

#### `UnifiedSearchBloc` — добавить `_resolvePeopleItems`

```dart
// Вызывается после _filterCurrentUser, до emit LoadedState
List<UnifiedSearchPersonItem> _resolvePeopleItems({
  required List<User> users,
  required List<UnifiedSearchConversation> conversations,
}) {
  // Индекс: userId → существующая приватная переписка
  final Map<String, UnifiedSearchConversation> conversationByCompanionId = {
    for (final conv in conversations)
      if (conv.type == UnifiedSearchConversationType.private &&
          conv.companion != null)
        conv.companion!.userId: conv,
  };

  return users.map((user) {
    final existing = conversationByCompanionId[user.userId];
    if (existing != null) {
      return UnifiedSearchExistingPersonItem(user: user, conversation: existing);
    }
    return UnifiedSearchNewPersonItem(user: user);
  }).toList(growable: false);
}
```

В `_onLoad` и `_onLoadMore`:

```dart
final peopleItems = _resolvePeopleItems(
  users: filteredResult.users,
  conversations: filteredResult.conversations,
);

emit(UnifiedSearchLoadedState(
  ...,
  peopleItems: peopleItems,
));
```

---

### Слой Presentation — `UnifiedSearchModalCard`

**Проблема:** `onPersonTap` делает `router.go(AppRoutes.conversationDraft(...))`. Это нарушает single responsibility: view не должен управлять навигацией на уровне роутера.

**Решение:** `showGeneralDialog` возвращает sealed-результат. Навигационное решение принимается в `ConversationsPanel`.

#### Sealed result type

```
lib/features/conversations_list/subfeatures/unified_search/
  presentation/models/unified_search_selection.dart
```

```dart
sealed class UnifiedSearchSelection {}

/// Пользователь выбран, переписки нет → нужен draft
final class UnifiedSearchDraftSelection extends UnifiedSearchSelection {
  const UnifiedSearchDraftSelection({required this.companion});
  final User companion;
}

/// Выбрана существующая переписка → прямая навигация
final class UnifiedSearchConversationSelection extends UnifiedSearchSelection {
  const UnifiedSearchConversationSelection({required this.conversationId});
  final String conversationId;
}
```

#### В `UnifiedSearchModalCard` — убрать `router.go`, вернуть результат

```dart
// Было:
onPersonTap: (user) {
  final router = GoRouter.of(context);
  Navigator.of(context).pop();
  router.go(AppRoutes.conversationDraft(user.userId));
},

// Стало — возвращаем selection через pop:
onPersonTap: (item) {
  if (item is UnifiedSearchExistingPersonItem) {
    Navigator.of(context).pop(
      UnifiedSearchConversationSelection(conversationId: item.conversation.id),
    );
  } else {
    Navigator.of(context).pop(
      UnifiedSearchDraftSelection(companion: item.user),
    );
  }
},

onConversationTap: (conversation) {
  Navigator.of(context).pop(
    UnifiedSearchConversationSelection(conversationId: conversation.id),
  );
},
```

В UI-секции "Люди" использовать `loaded.peopleItems` вместо `loaded.result.users`.

---

### Слой Presentation — `PrivateConversationBloc`

#### 1. `PrivateConversationDraftStartedEvent` — добавить `initialCompanion`

Сейчас при draft-старте делается лишний `getUserById` запрос. Из unified search пользователь уже известен.

```dart
final class PrivateConversationDraftStartedEvent extends PrivateConversationEvent {
  const PrivateConversationDraftStartedEvent({
    required this.companionId,
    this.initialCompanion, // новое: если есть — пропускаем getUserById
  });

  final String companionId;
  final User? initialCompanion;
}
```

В `_onDraftStarted`:

```dart
Future<void> _onDraftStarted(...) async {
  emit(const PrivateConversationLoadingState());
  final User companion = event.initialCompanion ??
      await _userInteractor.getUserById(userId: event.companionId);
  emit(PrivateConversationDraftState(companion: companion));
}
```

#### 2. `PrivateConversationNavigationConsumedEvent` — очистить pending ID

После того как переход был обработан, `pendingNavigationConversationId` должен быть сброшен, чтобы не «висеть» в состоянии.

```dart
final class PrivateConversationNavigationConsumedEvent
    extends PrivateConversationEvent {
  const PrivateConversationNavigationConsumedEvent();
}
```

В BLoC:

```dart
on<PrivateConversationNavigationConsumedEvent>(_onNavigationConsumed);

void _onNavigationConsumed(_, Emitter<PrivateConversationState> emit) {
  final current = state;
  if (current is PrivateConversationLoadedState) {
    emit(current.copyWith(pendingNavigationConversationId: null));
  }
}
```

#### 3. `PrivateConversationLoadedState.copyWith` — разрешить сброс pending ID

Текущий `copyWith` не позволяет передать `null` явно:

```dart
// Добавить sentinel-паттерн или Object? параметр:
PrivateConversationLoadedState copyWith({
  // ...
  Object? pendingNavigationConversationId = _sentinel,
}) {
  return PrivateConversationLoadedState(
    // ...
    pendingNavigationConversationId: 
      identical(pendingNavigationConversationId, _sentinel)
        ? this.pendingNavigationConversationId
        : pendingNavigationConversationId as String?,
  );
}
static const Object _sentinel = Object();
```

---

### Слой Presentation — `ConversationsPanel`

Центральное место изменений. Панель берёт на себя координацию между поиском и отображением.

#### Убрать `draftCompanionId` из конструктора

```dart
class ConversationsPanel extends StatefulWidget {
  const ConversationsPanel({
    super.key,
    this.selectedConversationId,
    // draftCompanionId — убран
  });

  final String? selectedConversationId;
}
```

#### Добавить локальный стейт черновика

```dart
class _ConversationsPanelState extends State<ConversationsPanel> {
  /// Компаньон активного черновика. null = черновика нет.
  User? _draftCompanion;

  /// ID переписки, созданной из черновика. Используется для сохранения
  /// стабильного ключа виджета после первого сообщения.
  String? _draftCreatedConversationId;
  
  // ...
}
```

#### `_openUnifiedSearch` — обработать результат

```dart
Future<void> _openUnifiedSearch(BuildContext context) async {
  final result = await showGeneralDialog<UnifiedSearchSelection>(
    context: context,
    transitionBuilder: slideFadeDialogTransition,
    pageBuilder: (_, _, _) => const UnifiedSearchModalCardWrapper(
      child: UnifiedSearchModalCard(),
    ),
  );

  if (!context.mounted || result == null) return;

  switch (result) {
    case UnifiedSearchConversationSelection(:final conversationId):
      // Существующая переписка → обычная навигация, draft сбрасывается
      setState(() {
        _draftCompanion = null;
        _draftCreatedConversationId = null;
      });
      GoRouter.of(context).go(AppRoutes.conversation(conversationId));

    case UnifiedSearchDraftSelection(:final companion):
      // Новый пользователь → draft в локальном стейте, БЕЗ router.go
      setState(() {
        _draftCompanion = companion;
        _draftCreatedConversationId = null;
      });
      // URL остаётся /conversations — черновик не сериализуется в URL
  }
}
```

#### `didUpdateWidget` — сбросить draft при внешней навигации

```dart
@override
void didUpdateWidget(ConversationsPanel old) {
  super.didUpdateWidget(old);
  
  final bool selectedChanged =
      widget.selectedConversationId != old.selectedConversationId;
  final bool isStillOurDraftConversation =
      widget.selectedConversationId == _draftCreatedConversationId;

  if (selectedChanged && !isStillOurDraftConversation) {
    // Пользователь перешёл к другой переписке — черновик закрыть
    setState(() {
      _draftCompanion = null;
      _draftCreatedConversationId = null;
    });
  }
}
```

#### `_onConversationCreated` — обработчик из wrapper

```dart
void _onConversationCreated(String conversationId) {
  // Запомнить ID, чтобы держать draft-виджет живым по тому же ключу
  setState(() {
    _draftCreatedConversationId = conversationId;
  });
  // Тихо обновить URL без пересоздания виджета
  GoRouter.of(context).replace(AppRoutes.conversation(conversationId));
  // Обновить список переписок слева
  context.read<AllConversationsListBloc>().add(const AllConversationsListLoadEvent());
}
```

#### Логика правой панели — стабильный ключ

```dart
// _draftCompanion != null: показываем draft-виджет
// Ключ = 'draft-{companionId}' — стабилен на протяжении всей жизни виджета,
// включая момент когда BLoC переходит из DraftState в LoadedState.
// Виджет НЕ пересоздаётся при router.replace.

final bool showDraft = _draftCompanion != null;

child: showDraft
    ? PrivateConversationScreenWrapper(
        key: ValueKey('draft-${_draftCompanion!.userId}'),
        draftCompanionId: _draftCompanion!.userId,
        initialCompanion: _draftCompanion,
        onConversationCreated: _onConversationCreated,
        child: PrivateConversationScreen(
          draftCompanionId: _draftCompanion!.userId,
        ),
      )
    : widget.selectedConversationId == null
        ? _buildEmptyState()
        : _buildConversationView(widget.selectedConversationId!),
```

---

### Слой Presentation — `PrivateConversationScreenWrapper` и `PrivateConversationScreen`

#### Wrapper — принять и передать `onConversationCreated`

```dart
class PrivateConversationScreenWrapper extends StatelessWidget {
  const PrivateConversationScreenWrapper({
    required this.child,
    this.conversationId,
    this.draftCompanionId,
    this.initialCompanion,
    this.onConversationCreated, // новый параметр
    super.key,
  });

  /// Вызывается когда черновик успешно конвертировался в реальную переписку.
  final void Function(String conversationId)? onConversationCreated;

  // ...
}
```

В `MultiBlocProvider` создавать BLoC с `initialCompanion`:

```dart
BlocProvider(
  create: (context) => PrivateConversationBloc(...)
    ..add(
      conversationId != null
          ? PrivateConversationStartedEvent(
              conversationId: conversationId!,
              initialCompanion: initialCompanion,
            )
          : PrivateConversationDraftStartedEvent(
              companionId: draftCompanionId!,
              initialCompanion: initialCompanion, // передаём из поиска
            ),
    ),
),
```

#### `PrivateConversationScreen` — `BlocListener` вызывает callback

```dart
BlocListener<PrivateConversationBloc, PrivateConversationState>(
  listenWhen: (previous, current) {
    if (previous is PrivateConversationLoadedState &&
        current is PrivateConversationLoadedState) {
      return previous.pendingNavigationConversationId !=
              current.pendingNavigationConversationId &&
          current.pendingNavigationConversationId != null;
    }
    if (previous is! PrivateConversationLoadedState &&
        current is PrivateConversationLoadedState) {
      return current.pendingNavigationConversationId != null;
    }
    return false;
  },
  listener: (context, state) {
    if (state is! PrivateConversationLoadedState) return;
    final id = state.pendingNavigationConversationId;
    if (id == null) return;

    // Вместо router.go — вызов callback из wrapper
    widget.onConversationCreated?.call(id);

    // Очистить pending ID в BLoC
    context.read<PrivateConversationBloc>().add(
      const PrivateConversationNavigationConsumedEvent(),
    );
  },
),
```

`widget.onConversationCreated` пробрасывается через `PrivateConversationScreen`:

```dart
class PrivateConversationScreen extends StatefulWidget {
  // ...
  final void Function(String conversationId)? onConversationCreated;
}
```

---

### Роутер — убрать draft-роут

#### `routes.dart`

```dart
abstract class AppRoutes {
  static const String conversations = '/conversations';
  static String conversation(String conversationId) =>
      '/conversations/$conversationId';

  // Удалить:
  // static String conversationDraft(String companionId) =>
  //     '/conversations/draft/$companionId';
}
```

#### `router.dart` — убрать GoRoute и safeguard в redirect

```dart
// Удалить GoRoute:
// GoRoute(
//   path: '/conversations/draft/:companionId',
//   ...
// ),

// В redirect — убедиться, что старый draft-URL редиректит на /conversations:
final bool isAppRoute =
    location == AppRoutes.home ||
    location.startsWith('${AppRoutes.conversations}/') ||
    location == AppRoutes.conversations ||
    // НЕ добавлять draft сюда — он теперь не существует
    location == AppRoutes.storage ||
    location.startsWith('${AppRoutes.storage}/') ||
    location == AppRoutes.passcodeLock;
```

---

## Итоговый флоу (после изменений)

```
Unified Search (person, нет переписки)
  → Navigator.pop(UnifiedSearchDraftSelection(companion: user))
  → ConversationsPanel: setState(_draftCompanion = user)
  → PrivateConversationScreenWrapper(key: 'draft-{userId}') создаётся
  → BLoC: DraftStartedEvent(companionId, initialCompanion: user) — нет лишнего fetch!
  → BLoC: DraftState (мгновенно, user уже есть)

Unified Search (person, переписка уже есть)
  → Navigator.pop(UnifiedSearchConversationSelection(conversationId: id))
  → ConversationsPanel: router.go('/conversations/:id') — как обычно

Пользователь отправляет первое сообщение из draft
  → POST getOrCreateByCompanion
  → BLoC: LoadedState(messages: [pending], pendingNavigationConversationId: newId)
  → BlocListener: widget.onConversationCreated?.call(newId)
  → ConversationsPanel._onConversationCreated(newId):
      setState(_draftCreatedConversationId = newId)
      router.replace('/conversations/:newId')  ← тихий replace, не go
  → ConversationsPanel ребилдится, НО:
      _draftCompanion != null → правая панель рендерит ТОТ ЖЕ виджет
      key = 'draft-{userId}' — СТАБИЛЕН → виджет не пересоздаётся
      BLoC жив, уже в LoadedState → никакого shimmer!
  → BLoC: NavigationConsumedEvent → pendingNavigationConversationId = null
  → AllConversationsListBloc: LoadEvent → переписка появляется в левом списке

Пользователь переходит к другой переписке
  → router.go('/conversations/:otherId')
  → ConversationsPanel.didUpdateWidget: selectedId изменился, не равен _draftCreatedConversationId
  → setState(_draftCompanion = null) → draft-виджет уничтожается
```

---

## Edge-cases


| Сценарий                                                                  | Поведение                                                                                                                                          |
| ------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
|                                                                           |                                                                                                                                                    |
| Отправка не удалась (POST упал)                                           | BLoC возвращает `DraftState(isCreatingConversation: false, failure: ...)`. `onConversationCreated` не вызывается. Toast с ошибкой, можно повторить |
| Пользователь открыл draft → ничего не отправил → кликнул другую переписку | `didUpdateWidget`: `selectedId != _draftCreatedConversationId` → `_draftCompanion = null` → draft-виджет уничтожается                              |
| Два черновика одновременно                                                | Не поддерживается. `setState(_draftCompanion = newUser)` заменяет предыдущий                                                                       |


---

## Чек-лист реализации

Порядок важен — каждый шаг компилируется независимо.

1. `unified_search_person_item.dart` — новая presentation-модель (sealed class)
2. `unified_search_selection.dart` — sealed result для `showGeneralDialog`
3. `UnifiedSearchLoadedState` — добавить `peopleItems`
4. `UnifiedSearchBloc._resolvePeopleItems` — логика дедупликации
5. `UnifiedSearchModalCard` — использовать `peopleItems`, `Navigator.pop(selection)`
6. `PrivateConversationDraftStartedEvent` — добавить `initialCompanion`
7. `PrivateConversationNavigationConsumedEvent` + handler в BLoC
8. `PrivateConversationLoadedState.copyWith` — поддержка сброса `pendingNavigationConversationId` в null
9. `PrivateConversationScreen` + `PrivateConversationScreenWrapper` — `onConversationCreated` callback, BlocListener без `router.go`
10. `ConversationsPanel` — убрать `draftCompanionId` из конструктора, добавить `_draftCompanion` стейт, `_openUnifiedSearch`, `_onConversationCreated`, `didUpdateWidget`
11. `routes.dart` — удалить `conversationDraft()`
12. `router.dart` — удалить GoRoute, проверить redirect

