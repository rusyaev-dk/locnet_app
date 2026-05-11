# Message Selection — план улучшения

> Статус: черновик · Дата: 2026-05-11

---

## 1. Текущее состояние и проблемы

### Что уже есть

| Компонент | Путь |
|---|---|
| `MessageSelectionCubit` | `message/subfeatures/message_selection/presentation/blocs/` |
| `SelectableMessageBubbleWrapper` | `…/message_selection/presentation/components/` |
| `MessagesSelectionAppBar` | `…/message_selection/presentation/components/` |
| `ForwardTargetPickerModalCard` | `…/message_selection/presentation/modals/` |
| `MessageSelectionModels` | `…/message_selection/domain/models/` |
| Drag-select | Дублируется в `PrivateMessagesList`, `GroupMessagesList` (и, предположительно, `ChannelMessagesList`) |

### Диагностированные проблемы

**Критические (UX сломан)**

1. **Нет tap-to-toggle в режиме выделения.** `SelectableMessageBubbleWrapper` использует только `onLongPress` и никогда не вызывает `onToggleSelection` по обычному тапу. После входа в режим выделения нельзя добавить/снять другие сообщения тапом — это главная причина «дёрганности».

2. **Drag-select работает только на Desktop.** Логика построена на `kPrimaryMouseButton` + `MouseRegion.onEnter`. На мобильном тач-устройстве (или трекпаде без кнопки) drag-выделение не работает вообще.

3. **Логика дублируется в трёх местах.** `_isDragSelecting` и `_visitedIds` скопированы в `PrivateMessagesList`, `GroupMessagesList` и, скорее всего, в `ChannelMessagesList`. Любой фикс нужно вносить три раза.

**Визуальные / ощущения**

4. **Нет чекбокса.** При выделении сообщение просто меняет фон (`primary.withOpacity(0.14)`). Пользователь не видит привычный индикатор «выбрано / не выбрано».

5. **Нет хаптической обратной связи** при входе в режим выделения и при тоггле.

6. **AppBar минималистичен.** Только счётчик + Forward + Delete. Нет "Select All", нет Copy (актуально при выделении одного сообщения), нет счётчика в формате `3 / 150`.

7. **Вся ListView перестраивается на каждый toggle** — `context.watch<MessageSelectionCubit>()` в `build()` вызывает ребилд всех элементов списка.

8. **Анимация входа/выхода из режима выделения** не реализована — AppBar и чекбоксы просто появляются/исчезают.

---

## 2. Цель

Переработать фичу выделения так, чтобы:

- Ощущение было как в Telegram Desktop / iOS: плавный вход, чёткая визуальная обратная связь, удобные жесты и на Desktop, и на мобильном.
- Весь код выделения жил в одном месте (`message_selection` subfeature) и не дублировался.
- Производительность не деградировала при большом количестве сообщений.

---

## 3. Архитектура: вынос в subfeature

### Новая структура файлов

```
lib/features/message/subfeatures/message_selection/
├── domain/
│   └── models/
│       └── message_selection_models.dart          # без изменений
├── presentation/
│   ├── blocs/
│   │   ├── message_selection_cubit.dart           # дополнить: selectRange, selectAll
│   │   └── message_selection_state.dart
│   ├── components/
│   │   ├── selectable_message_bubble_wrapper.dart # переработать
│   │   ├── selection_checkbox.dart                # NEW: анимированный чекбокс
│   │   ├── messages_selection_app_bar.dart        # дополнить: selectAll, copy, счётчик
│   │   └── components.dart
│   ├── mixins/
│   │   └── drag_select_mixin.dart                 # NEW: вся drag-логика в одном месте
│   └── modals/
│       └── forward_target_picker_modal_card.dart  # без изменений
```

`PrivateMessagesList`, `GroupMessagesList`, `ChannelMessagesList` используют `DragSelectMixin` и убирают собственный дублированный код.

---

## 4. Фаза 1 — Критические исправления

### 4.1 Tap-to-toggle в режиме выделения

В `SelectableMessageBubbleWrapper` добавить условный `onTap`:

```dart
GestureDetector(
  onLongPress: onEnterSelectionMode,
  onTap: isSelectionMode ? onToggleSelection : null,
  child: AnimatedContainer(…),
)
```

`isSelectionMode` прокидывается снаружи (уже есть `isSelected`, добавить `isSelectionMode`).

Чтобы таппабельность в selection mode не конфликтовала с пузырём (который тоже может обрабатывать тапы), `MessageBubble` должен «проглатывать» свои жесты когда `isSelectionMode == true`. Добавить пропс `bool absorbPointer` и обернуть содержимое в `AbsorbPointer(absorbing: absorbPointer)`.

### 4.2 `DragSelectMixin` — единый drag-select для Desktop и Touch

Вынести логику в миксин `DragSelectMixin<T extends StatefulWidget>`:

```dart
mixin DragSelectMixin<T extends StatefulWidget> on State<T> {
  bool _isDragSelecting = false;
  int? _dragStartIndex;       // индекс начала drag
  final Set<String> _visitedIds = {};

  // Вызывать из build() на Listener
  void onPointerDown(PointerDownEvent e, MessageSelectionCubit cubit) { … }
  void onPointerMove(PointerMoveEvent e, List<String> orderedIds, MessageSelectionCubit cubit) { … }
  void onPointerUp(PointerUpEvent e) { … }
}
```

**Desktop:** как сейчас — `kPrimaryMouseButton` + `MouseRegion.onEnter`.

**Touch / trackpad:** использовать `onPointerMove` + hit-testing по `RenderBox` через `GlobalKey` каждого элемента. При движении пальца вычислять, над каким элементом находится указатель, и тоглить его.

```dart
void _hitTestPointer(Offset globalPosition, List<String> orderedIds, MessageSelectionCubit cubit) {
  for (final id in orderedIds) {
    final key = _messageKeys[id];
    final box = key?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) continue;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    if (rect.contains(globalPosition) && !_visitedIds.contains(id)) {
      _visitedIds.add(id);
      cubit.toggleMessage(id);
      break;
    }
  }
}
```

### 4.3 Хаптическая обратная связь

В `MessageSelectionCubit.enterSelectionMode` и в `toggleMessage` ничего не менять (логика чистая).

Вызывать из `SelectableMessageBubbleWrapper`:

```dart
onLongPress: () {
  HapticFeedback.mediumImpact();
  onEnterSelectionMode();
},
onTap: isSelectionMode
  ? () {
      HapticFeedback.selectionClick();
      onToggleSelection();
    }
  : null,
```

### 4.4 Устранение лишних ребилдов

Заменить `context.watch<MessageSelectionCubit>()` в `itemBuilder` на `BlocSelector`:

```dart
BlocSelector<MessageSelectionCubit, MessageSelectionState, bool>(
  selector: (state) => state.isSelected(message.id),
  builder: (context, isSelected) => SelectableMessageBubbleWrapper(
    isSelected: isSelected,
    isSelectionMode: context.select(
      (MessageSelectionCubit c) => c.state.isSelectionMode,
    ),
    …
  ),
)
```

Теперь при тогле одного сообщения перестраиваются только два элемента (выбранный + предыдущий), а не весь список.

---

## 5. Фаза 2 — Визуальный polish

### 5.1 Виджет `SelectionCheckbox`

Анимированный чекбокс, который «выезжает» слева при входе в режим выделения:

```dart
class SelectionCheckbox extends StatelessWidget {
  const SelectionCheckbox({required this.isVisible, required this.isChecked, super.key});

  final bool isVisible;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: isVisible
          ? Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: isChecked
                    ? Icon(Icons.check_circle, key: const ValueKey(true),
                        color: Theme.of(context).colorScheme.primary)
                    : Icon(Icons.radio_button_unchecked, key: const ValueKey(false),
                        color: Theme.of(context).colorScheme.outline),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
```

Встраивать в `SelectableMessageBubbleWrapper`:

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    SelectionCheckbox(isVisible: isSelectionMode, isChecked: isSelected),
    Expanded(child: MessageBubble(…, absorbPointer: isSelectionMode)),
  ],
)
```

### 5.2 Highlight-анимация пузыря

Текущая анимация (140ms `easeOut`) — нормальная. Добавить `ScaleTransition` при первом выборе (`isSelected` перешёл из `false` в `true`):

```dart
// В SelectableMessageBubbleWrapper использовать AnimatedScale:
AnimatedScale(
  scale: isSelected ? 0.985 : 1.0,
  duration: const Duration(milliseconds: 120),
  child: AnimatedContainer(…),
)
```

### 5.3 Улучшенный `MessagesSelectionAppBar`

Добавить:

- **"Выбрать все"** — `IconButton(icon: Icons.select_all)`. Вызывает новый метод `MessageSelectionCubit.selectAll(allIds)`.
- **"Копировать"** — активен только когда выбрано ровно одно текстовое сообщение.
- **Счётчик** в формате `«3 из 150»` (или просто `«3»` если total неизвестен).
- **Анимированное появление** AppBar через `AnimatedSwitcher` на уровне `Scaffold.appBar`.

Новая сигнатура:

```dart
class MessagesSelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MessagesSelectionAppBar({
    required this.selectedCount,
    required this.totalCount,          // NEW
    required this.onClosePressed,
    required this.onDeletePressed,
    required this.onForwardPressed,
    required this.onSelectAllPressed,  // NEW
    this.onCopyPressed,                // NEW (nullable — активен только при одном выбранном)
    this.canDelete = true,
    this.canForward = true,
    super.key,
  });
```

### 5.4 Анимация входа/выхода из режима выделения

На уровне `Scaffold` (в `PrivateConversationScreen` и аналогах) заменить прямое переключение AppBar на `AnimatedSwitcher`:

```dart
appBar: AnimatedSwitcher(
  duration: const Duration(milliseconds: 220),
  transitionBuilder: (child, animation) => SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
    child: FadeTransition(opacity: animation, child: child),
  ),
  child: isSelectionMode
      ? MessagesSelectionAppBar(key: const ValueKey('selection'), …)
      : ConversationHeader(key: const ValueKey('normal'), …),
),
```

---

## 6. Фаза 3 — Расширенные возможности

### 6.1 Range Selection (Desktop, Shift+Click)

В `SelectableMessageBubbleWrapper` при `onTap` проверять `HardwareKeyboard.instance.isShiftPressed`. Если да — вызывать `cubit.selectRange(fromId, toId)`.

Добавить в `MessageSelectionCubit`:

```dart
void selectRange(MessageId fromId, MessageId toId, List<MessageId> orderedIds) {
  final int fromIdx = orderedIds.indexOf(fromId);
  final int toIdx = orderedIds.indexOf(toId);
  if (fromIdx == -1 || toIdx == -1) return;
  final int lo = min(fromIdx, toIdx);
  final int hi = max(fromIdx, toIdx);
  final range = orderedIds.sublist(lo, hi + 1).toSet();
  emit(state.copyWith(
    selectedMessageIds: Set.from(state.selectedMessageIds)..addAll(range),
  ));
}
```

`_lastTappedId` хранится в стейте списка и передаётся при следующем shift-клике.

### 6.2 Select All / Deselect All

```dart
void selectAll(Iterable<MessageId> allIds) {
  emit(state.copyWith(
    isSelectionMode: true,
    selectedMessageIds: Set.from(allIds),
  ));
}

void deselectAll() {
  emit(state.copyWith(
    selectedMessageIds: const {},
    // isSelectionMode остаётся true — пользователь не вышел из режима
  ));
}
```

Кнопка в AppBar: когда все выбраны — показывает "Снять все", иначе "Выбрать все".

### 6.3 Клавиатурные шорткаты (Desktop)

Обернуть `Scaffold` конкретного экрана (или использовать глобальный `Shortcuts` в `ConversationScreen`) и добавить:

| Шорткат | Действие |
|---|---|
| `Escape` | Выйти из режима выделения |
| `Ctrl+A` | Select All |
| `Delete` | Удалить выбранные |
| `Ctrl+C` | Копировать (если одно выбрано) |

### 6.4 Свайп-для-выбора (мобильный UX)

Горизонтальный свайп вправо на пузыре (как в WhatsApp) может быть альтернативным способом войти в режим выделения или тогглить сообщение. Реализовать через `Dismissible`-like wrapper с порогом `dx > 40`:

```dart
GestureDetector(
  onHorizontalDragEnd: (details) {
    if (details.primaryVelocity != null && details.primaryVelocity! > 200) {
      if (isSelectionMode) {
        onToggleSelection();
      } else {
        onEnterSelectionMode();
      }
    }
  },
```

---

## 7. Что не меняем

- `MessageSelectionCubit` остаётся в `message_selection/presentation/blocs/` — это правильное место.
- `ForwardTargetPickerModalCard` — логика пересылки не затрагивается.
- `MessageSelectionState` — расширяем методами, структура не меняется.
- Слой данных (domain) — выделение чисто UI-концепт, в домен не лезем.

---

## 8. Порядок выполнения

| Приоритет | Задача | Сложность |
|---|---|---|
| 🔴 P0 | Tap-to-toggle в режиме выделения | XS |
| 🔴 P0 | `AbsorbPointer` в `MessageBubble` при selection mode | XS |
| 🔴 P1 | `DragSelectMixin` + touch hit-test drag | M |
| 🟡 P1 | Хаптическая обратная связь | XS |
| 🟡 P1 | `BlocSelector` вместо `context.watch` в itemBuilder | S |
| 🟡 P2 | `SelectionCheckbox` виджет | S |
| 🟡 P2 | Улучшенный `MessagesSelectionAppBar` (Select All, Copy, счётчик) | S |
| 🟢 P2 | Анимация AppBar (AnimatedSwitcher) | S |
| 🟢 P3 | Range Selection (Shift+Click) | M |
| 🟢 P3 | Select All / Deselect All в кубите | XS |
| 🟢 P3 | Keyboard shortcuts (Escape, Ctrl+A, Delete) | S |
| ⚪ P4 | Свайп-для-выбора (мобильный) | M |

---

## 9. Тест-сценарии для ручного QA

- [ ] Long press → входим в selection mode, первое сообщение помечено
- [ ] Tap по невыбранному сообщению в selection mode → помечается
- [ ] Tap по выбранному сообщению → снимается
- [ ] Drag по нескольким сообщениям (мышь, Desktop) → все помечаются
- [ ] Drag пальцем по нескольким сообщениям (мобильный) → все помечаются
- [ ] Shift+Click → выделяется диапазон (Desktop)
- [ ] Escape → выход из режима, анимация AppBar
- [ ] "Выбрать все" → все сообщения помечены, кнопка меняется на "Снять все"
- [ ] Счётчик в AppBar обновляется при каждом toggle
- [ ] Copy активна только при одном выбранном сообщении
- [ ] При выходе из selection mode ни одного сообщения не остаётся помеченным
- [ ] Нет заметных фризов при drag-выделении 50+ сообщений
