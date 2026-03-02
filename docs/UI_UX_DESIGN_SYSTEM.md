# UI/UX Design System — Locnet App

> **Версия:** 1.0  
> **Назначение:** Техническая спецификация дизайн-системы для генерации Flutter UI.  
> Этот документ — единственный источник истины по визуальному языку приложения.  
> Документ не описывает код — он описывает систему правил, токенов и компонентов.

---

## 0. Философия дизайна

### Ключевые принципы
1. **Минимализм.** Нет украшений ради украшений. Каждый визуальный элемент несёт функцию.
2. **Чёрно-белая монохромная палитра.** Акцент — только на интерактивных элементах через контраст. Никаких цветных акцентов (синий/зелёный/красный) вне ошибок.
3. **Иерархия через пространство.** Отступы, а не рамки, разделяют логические блоки.
4. **Воздух важен.** Достаточные вертикальные отступы между группами контента — обязательное требование.
5. **Консистентность.** Одинаковые задачи — одинаковые компоненты. Нет самодеятельности в UI.
6. **Скорость восприятия.** Заголовок → краткое описание → элементы управления. Всегда.

### Запрещено
- Жёсткие рамки вокруг input-полей (только для состояния ошибки)
- Синие/зелёные/фиолетовые цвета за пределами `error`-токена
- `withOpacity` — только `withAlpha`
- Хардкод размеров (`width: 300`, `fontSize: 14`) — только токены
- Функции, возвращающие `Widget` — только `StatelessWidget` / `StatefulWidget`
- `<Widget>` в `children:`
- `Theme.of(context)` напрямую — только расширения контекста

---

## 1. Токены цвета — `AppColorScheme`

Цвета получают через `context.colorScheme`. Схема полностью монохромная (серые тона).

### Семантические роли

| Токен | Светлая тема | Тёмная тема | Назначение |
|---|---|---|---|
| `primary` | `#444444` | `#BBBBBB` | Основной акцент, кнопки, активные иконки |
| `onPrimary` | `#FFFFFF` | `#111111` | Текст/иконки поверх `primary` |
| `primaryContainer` | `#DDDDDD` | `#555555` | Контейнеры с акцентом (chips, badges) |
| `onPrimaryContainer` | `#111111` | `#F5F5F5` | Текст внутри `primaryContainer` |
| `secondary` | `#E5E5E5` | `#252525` | Фон модальных карточек, вторичный контейнер |
| `onSecondary` | `#111111` | `#F0F0F0` | Текст поверх `secondary` |
| `surface` | `#F8F8F8` | `#111111` | Основной фон экранов |
| `onSurface` | `#111111` | `#F5F5F5` | Основной текст |
| `surfaceDim` | `#E0E0E0` | `#111111` | Приглушённый фон |
| `surfaceBright` | `#FFFFFF` | `#1E1E1E` | Яркий фон (карточки, поп-апы) |
| `surfaceContainerLowest` | `#FFFFFF` | `#000000` | Самый светлый слой |
| `surfaceContainerLow` | `#F2F2F2` | `#111111` | Группы настроек, фон секций |
| `surfaceContainer` | `#E6E6E6` | `#1E1E1E` | Плашки, сегментированные контролы |
| `surfaceContainerHigh` | `#D9D9D9` | `#2A2A2A` | Выбранные/активные элементы списка |
| `surfaceContainerHighest` | `#CCCCCC` | `#3A3A3A` | Наиболее контрастный контейнер |
| `onSurfaceVariant` | `#666666` | `#B0B0B0` | Вторичный текст, подписи, иконки |
| `outline` | `#D0D0D0` | `#555555` | Видимые разделители, рамки ошибки |
| `outlineVariant` | `#E0E0E0` | `#2A2A2A` | Тонкие разделители, `Divider` |
| `error` | `#888888` | `#888888` | Деструктивные действия, ошибки |
| `errorContainer` | `#EDEDED` | `#444444` | Фон предупреждений |
| `onErrorContainer` | `#111111` | `#F5F5F5` | Текст в предупреждении |
| `approval` | `#777777` | `#777777` | Успешные состояния |
| `hoverOverlay` | `#0D000000` (5%) | `#14000000` (8%) | Наложение при hover |
| `pressedOverlay` | `#1A000000` (10%) | `#21000000` (13%) | Наложение при tap |
| `shimmer` | `#E5E5E5` | `#2A2A2A` | Скелетон-анимация |
| `inverseSurface` | `#111111` | `#F5F5F5` | Инверсный фон (тосты, тултипы) |
| `onInverseSurface` | `#F5F5F5` | `#111111` | Текст на инверсном фоне |

### Правила применения цветов

1. **Фон экрана** → `surface`
2. **Фон модальной карточки** → `secondary`
3. **Фон группы настроек / карточки** → `surfaceContainerLow`
4. **Активный элемент списка / сайдбара** → `surfaceContainerHigh`
5. **Основной текст** → `onSurface`
6. **Вторичный текст / подписи** → `onSurfaceVariant`
7. **Разделители (Divider)** → `outlineVariant`, thickness 1
8. **Кнопка-деструктор** → `error` (текст и иконка)
9. **Основная кнопка (AppPrimaryButton)** → bg: `primary`, текст: `onPrimary`
10. **Неактивный элемент** → цвет `onSurfaceVariant`, не ниже

---

## 2. Типографика — `AppTextScheme`

Доступ через `context.textScheme`. Только `.copyWith()` для переопределения цвета/веса.

### Иерархия стилей

| Имя | Базовый стиль | Размер | Вес | Использование |
|---|---|---|---|---|
| `display` | `displaySmall` | 36px | normal | Заголовки splash, onboarding |
| `headline` | `headlineSmall` | 24px / ProductSans | normal | Заголовки модальных карточек, section header |
| `title` | `titleMedium` | 16px | w500 | Заголовок экрана, подзаголовок секции |
| `subtitle` | `titleSmall` | 14px | w500 | Метка, вторичный заголовок карточки |
| `body` | `bodyMedium` | 14px | normal | Основной текст сообщений, описаний |
| `label` | `labelMedium` | 12px / ProductSans | w500 | Подписи, значения настроек, chip текст |
| `caption` | `labelSmall` | 11px | w500 | Метки групп (uppercase), временные метки, версия приложения |

### Правила типографики

1. Использовать только 7 стилей выше — не создавать свои.
2. Изменять только `color` и `fontWeight` через `.copyWith()`.
3. Не хардкодить `fontSize` — только из `AppTextStyle.*`.
4. Основной текст элемента → `label` или `body`.
5. Подписи под элементами → `caption`.
6. Заголовки секций в настройках → `headline` + `fontWeight: w700`.
7. Лейблы групп (uppercase) → `caption` + `letterSpacing: 0.6` + uppercase.
8. Все `Text` с возможным переполнением → `maxLines` + `overflow: TextOverflow.ellipsis`.

---

## 3. Токены отступов — `AppSpacing`

Доступ через `context.designTokens.spacing`.

| Токен | Значение | Типичное применение |
|---|---|---|
| `xxs` | 4px | Зазор между иконкой и текстом в компактных элементах |
| `xs` | 8px | Внутренний gap между строками, мелкие отступы |
| `sm` | 12px | Padding кнопок, внутренний отступ карточек |
| `md` | 16px | Стандартный horizontal padding в списках и группах |
| `lg` | 20px | Горизонтальный padding страниц/модалок |
| `xl` | 24px | Вертикальный отступ между блоками, после section header |
| `xxl` | 32px | Между крупными секциями |

**Правило:** между группами настроек — `SizedBox(height: 20)`. Между секцией header и первой группой — `SizedBox(height: 24)` (включено в `SettingsSectionHeader`).

---

## 4. Токены радиусов — `AppRadii`

Доступ через `context.radii`. Стиль — telegram-desktop-like (мягкий, но не слишком округлый).

| Токен | Значение | Применение |
|---|---|---|
| `small` | 4px | Редко, мелкие декоративные элементы |
| `medium` | 6px | Внутренние скруглённые плашки |
| `large` | 8px | Выделенные блоки, теги |
| `defaultRadius` | 6px | Input поля, кнопки (`AppPrimaryButton`) |

**Отдельно** (не из токенов, используются в UI-компонентах):
- Модальная карточка (`AppModalCard`): `borderRadius: 14`
- `SettingsGroupCard` / `SegmentedControl`: `borderRadius: 16` (или `10–12` для внутренних вложений)
- `CompanionAvatar`: `BoxShape.circle`
- `ChipButton`: `BorderRadius.circular(14)`

---

## 5. Токены движения — `AppMotion`

Доступ через `context.designTokens.motion`.

| Токен | Значение | Применение |
|---|---|---|
| `fast` | 150ms | Hover/press-оверлей, маленькие переходы цвета |
| `medium` | 250ms | Переходы состояний, смена контента |
| `fastCurve` | `Curves.easeOut` | Быстрые микро-анимации |
| `mediumCurve` | `Curves.easeOutCubic` | Переходы, анимированные контейнеры |

**Правила:**
- Нет bounce/elastic кривых — только `easeOut`, `easeOutCubic`, `easeInOut`.
- `AnimatedContainer`, `AnimatedDefaultTextStyle`, `TweenAnimationBuilder` — стандартный инструмент.
- Нет анимаций > 300ms в интерактивных элементах.

---

## 6. Токены границ — `AppBorders`

Доступ через `context.borders`.

| Токен | Значение | Применение |
|---|---|---|
| `thin` | 1.0px | `Divider`, рамки в нормальном состоянии |
| `medium` | 1.5px | Рамка input при focused-error |

---

## 7. Каталог компонентов

### 7.1 AppPrimaryButton

**Файл:** `uikit/buttons/primary_button.dart`

**Характеристики:**
- Фон: `colorScheme.primary`, текст: `colorScheme.onPrimary`
- Высота: 40px (по умолчанию)
- Радиус: `radii.defaultRadiusValue` (6px)
- Elevation: 0
- Стиль текста: `textScheme.title` + `fontWeight: w600`
- Неактивное состояние: фон `colorScheme.outline`
- Загрузка: `CircularProgressIndicator` `strokeWidth: 2.6`, вместо текста
- Анимация переключения loading/text: `AnimatedSwitcher` 250ms

**Применение:** Основное действие в экране/модалке. Не более одной на видимой области.

---

### 7.2 ChipButton

**Файл:** `uikit/buttons/chip_button.dart`

**Характеристики:**
- Высота: 32px
- Радиус: `BorderRadius.circular(14)`
- Фон: `colorScheme.surfaceContainer` (по умолчанию)
- Текст/иконка: `colorScheme.onSurfaceVariant`
- Стиль текста: `textScheme.label`
- Поддерживает: только иконку, только текст, иконку + текст
- Опциональная рамка: `borderColor` + `borderWidth`

**Применение:** Фильтры в списках, теги, вторичные действия без ярко выраженного CTA.

---

### 7.3 AppTileButton + AppTileButtonGroupCard

**Файл:** `uikit/buttons/tile_button.dart`

**AppTileButton — характеристики:**
- Иконка (20px, `onSurfaceVariant`) + заголовок + опциональное значение
- С `value`: caption (вторичный текст) + subtitle (основной текст)
- Без `value`: только subtitle
- Padding: `horizontal: 14, vertical: 12`

**AppTileButtonGroupCard — характеристики:**
- Контейнер: `colorScheme.surface`, радиус `radii.defaultRadiusValue`
- Разделитель: `Divider(height: 1, indent: 56, color: outlineVariant)`

---

### 7.4 SegmentedControl

**Файл:** `uikit/tabbars/segmented_control.dart`

**Характеристики:**
- Высота: 52px (normal), 40px (compact)
- Контейнер: `colorScheme.surface` + `outlineVariant` border
- Индикатор: `primary.withAlpha(0x14)` фон + `primary.withAlpha(0x3D)` border + box-shadow
- Анимация индикатора: `AnimatedAlign` 260ms `easeOutCubic`
- Активный сегмент: `primary` цвет, `FontWeight.w700`
- Неактивный: `onSurfaceVariant`, `FontWeight.w500`
- Радиус контейнера: 16px (normal), 12px (compact)
- Радиус индикатора: 12px (normal), 8px (compact)
- Каждый сегмент: иконка + текст

---

### 7.5 CustomTextField

**Файл:** `uikit/text_fields/text_field.dart`

**Характеристики:**
- Фон: `colorScheme.surface`
- **Без рамки в нормальном состоянии** (`BorderSide.none` для enabled/focused/disabled)
- Рамка только при ошибке: `colorScheme.error`, `borders.thin`
- Focused error: `borders.medium`
- Радиус: `radii.defaultRadiusValue`
- Content padding: `horizontal: 16, vertical: 12`
- Текст ввода: `textScheme.body` + `colorScheme.onSurface`
- Label: `textScheme.subtitle` + `colorScheme.onSurfaceVariant`
- Hint: `textScheme.body` + `onSurfaceVariant.withAlpha(179)`
- Счётчик символов: `textScheme.label`, при превышении → `colorScheme.error`

---

### 7.6 AppModalCard

**Файл:** `core/presentation/modals/app_modal_card.dart`

**Характеристики:**
- Фон: `colorScheme.secondary`
- Радиус: 14px
- `maxWidth`: 420px (default), изменяется под конкретный экран
- `verticalInset`: 48px (отступ от краёв экрана по вертикали)
- Контент: любой `Widget`-дочерний (обычно `Column` с `Expanded`)
- `ClipRRect` по радиусу

**Правило для модалок с двумя панелями (как Settings):** `maxWidth: MediaQuery.sizeOf(context).width * 0.5`

---

### 7.7 CompanionAvatar

**Файл:** `core/presentation/components/companion_avatar.dart`

**Характеристики:**
- Форма: круг (`BoxShape.circle`)
- Рамка: `colorScheme.outlineVariant`, 1px
- С URL: `CachedNetworkImage` + fallback на инициалы
- Без URL: градиент из HSL на основе хеша `text`-строки + инициалы
- Инициалы: белый текст, `FontWeight.w700`, размер = `avatarSize * ratio (0.34–0.50)`
- Стандартный размер: 32px, в настройках: 40px

---

### 7.8 InfoWidget

**Файл:** `core/presentation/components/info_widget.dart`

**Характеристики:**
- Горизонтальный padding: 50px (центрированный)
- Иконка: 65px, `surfaceDim.withAlpha(170)`
- Текст: `textScheme.headline` + `surfaceDim.withAlpha(170)`, `maxLines: 3`
- Опциональная кнопка: `TextButton` с `colorScheme.primary`
- Анимация иконки: через `flutter_animate` + `iconAnimationEffect`

**Применение:** Пустые состояния, экраны ошибок. Всегда обёрнут в `Center`.

---

### 7.9 AppAlertDialog

**Файл:** `uikit/dialogs/alert_dialog.dart`

**Характеристики:**
- На iOS: `CupertinoAlertDialog`
- На Android/Web: Material `AlertDialog`
- Действия передаются через `AppAlertDialogAction`

---

## 8. Компоненты настроек (Settings UI Kit)

Эти компоненты находятся в `features/settings/presentation/components/` и используются во всех секциях настроек. Стиль — минималистичный (ChatGPT-like).

### 8.1 SettingsSectionHeader

**Назначение:** Заголовок секции.  
**Анатомия:** `headline` (bold) → `SizedBox(height: 6)` → `label` (secondary text) → `SizedBox(height: 24)`.

---

### 8.2 SettingsGroupCard

**Назначение:** Группа связанных настроек в одном визуальном блоке.  
**Анатомия:**
- Опциональный лейбл группы: `caption` + uppercase + `letterSpacing: 0.6` + `onSurfaceVariant`, снаружи над контейнером, `padding-left: 4, padding-bottom: 8`
- Контейнер: `surfaceContainerLow`, `borderRadius: 16`
- Между элементами: `Divider(height: 1, indent: 16, color: outlineVariant)`
- Опциональное описание под группой: `caption` + `onSurfaceVariant`, `padding-left: 4, padding-top: 8`

---

### 8.3 SettingsSwitchTile

**Назначение:** Строка с переключателем.  
**Анатомия:** `padding: horizontal 16, vertical 13` → `Expanded(Column(title + subtitle?))` → `Switch`  
- Заголовок: `label` + `onSurface`
- Подзапись: `caption` + `onSurfaceVariant`, `height: 1.3`
- Неактивный (`enabled: false`): заголовок → `onSurfaceVariant`, Switch → disabled

---

### 8.4 SettingsNavTile

**Назначение:** Строка навигации (открывает новый экран/модал).  
**Анатомия:** `padding: horizontal 16, vertical 13` → `[leadingIcon?]` → `Expanded(Column(title + subtitle?))` → `[trailingText?]` → `[chevron_right?]`  
- Заголовок: `label` + `onSurface`
- `trailingText`: `caption` + `onSurfaceVariant`
- Chevron: `Icons.chevron_right`, 18px, `onSurfaceVariant`
- Неактивный: заголовок → `onSurfaceVariant`, `onTap: null`

---

### 8.5 SettingsActionTile

**Назначение:** Нажимаемое действие (не переход, а действие — очистить, выйти и т.д.).  
**Анатомия:** `padding: horizontal 16, vertical 13` → `[leadingIcon?]` → `Text(title)`  
- Стандартный: `label` + `onSurface`
- Деструктивный (`destructive: true`): `label` + `error`, `fontWeight: w500`
- Неактивный: `onSurfaceVariant`

---

### 8.6 SettingsSegmentedTile

**Назначение:** Строка с встроенным сегментным переключателем.  
**Анатомия:**  
```
padding: horizontal 16, vertical 12
  Column:
    label (title) + optional caption (subtitle)
    SizedBox(height: 10)
    _SegmentedSelector (animated, no icon version)
```
- Selector контейнер: `surfaceContainer`, `borderRadius: 10`, `padding: 3`
- Активный сегмент: `surfaceContainerHighest`, `borderRadius: 8`, `AnimatedContainer` 160ms
- Текст активного: `caption` + `onSurface` + `FontWeight.w600`
- Текст неактивного: `caption` + `onSurfaceVariant` + `FontWeight.w400`

---

### 8.7 SettingsInfoCard

**Назначение:** Информационная / предупреждающая карточка.  
**Анатомия:** `Container(padding: horizontal 14, vertical 12, borderRadius: 12)` → `Icon(16px)` + `Expanded(caption, height: 1.4)`

Варианты:
- `info`: фон `surfaceContainerHigh`, иконка/текст `onSurfaceVariant`
- `warning`: фон `errorContainer.withAlpha(180)`, иконка/текст `onErrorContainer`

---

## 9. Паттерны компоновки экранов

### 9.1 Модальные карточки

**Структура:**
```
AppModalCard
  └── Column
        ├── Header (фиксированная высота, не скроллируется)
        │     ├── Заголовок (headline)
        │     └── [Кнопка закрытия / назад]
        └── Expanded
              └── content (обычно ScrollView или список)
```

**Правила:**
- Заголовок всегда вне зоны скролла
- `maxWidth` выбирается по содержимому: 420px (стандарт), 50% ширины экрана (двухпанельные)
- Анимация открытия: `slideFadeDialogTransition` (slide + fade)
- Цвет фона модалки: `colorScheme.secondary`

---

### 9.2 Двухпанельный лейаут (Settings-style)

**Структура:**
```
Column
  ├── SettingsHeader (fixed)
  └── Expanded
        └── LayoutBuilder
              └── Row
                    ├── Expanded(flex: 2) → Sidebar
                    ├── VerticalDivider(width: 1, outlineVariant)
                    └── Expanded(flex: 5) → Content
```

**Адаптивность:**
- `constraints.maxWidth < 600` → compact sidebar (только иконки, без текста)
- Профиль-превью в нижней части сайдбара (после `Expanded(ListView)` + `Divider`)

---

### 9.3 Полноэкранные секции (Content area)

**Структура:**
```
SingleChildScrollView(padding: horizontal 20, vertical 16)
  └── Column(crossAxisAlignment: start)
        ├── SettingsSectionHeader(title, description)
        ├── SettingsGroupCard(title: 'Группа A', [...])
        ├── SizedBox(height: 20)
        ├── SettingsGroupCard(title: 'Группа B', [...])
        ├── SizedBox(height: 8)           ← опциональный SettingsInfoCard
        ├── SettingsInfoCard(...)
        ├── SizedBox(height: 20)
        └── SizedBox(height: 8)          ← нижний отступ
```

---

### 9.4 Список сообщений / чатов

**Паттерн — тайл разговора:**
```
Material (transparent)
  └── InkWell
        └── Row
              ├── CompanionAvatar (40–48px)
              ├── SizedBox(width: 12)
              └── Expanded
                    └── Column
                          ├── Row [name + timestamp]
                          └── Row [last message + badge?]
```

---

### 9.5 Сайдбар (основная навигация)

**Структура:**
```
Column
  ├── Expanded
  │     └── ListView (navigation items)
  │           └── _SidebarItem(icon, label, isSelected, compact, onTap)
  └── [Divider + ProfilePreview]
```

**Элемент навигации — активный:** `surfaceContainerHigh`, `borderRadius: 12`  
**Элемент навигации — неактивный:** прозрачный  
**Compact mode:** только иконка (18px), `Center`, `padding: horizontal 8, vertical 10`  
**Full mode:** иконка + `SizedBox(width: 10)` + `Expanded(Text, overflow: ellipsis)`

---

## 10. Паттерны состояний

### 10.1 Loading

- В модальных карточках: `Center(CircularProgressIndicator())`
- В контент-секциях: `const Center(child: CircularProgressIndicator())`
- В инлайн-кнопке: `AnimatedSwitcher` → `CircularProgressIndicator` вместо текста
- Скелетон: контейнеры `shimmer`-цвета с `borderRadius`

### 10.2 Error

- Модальный уровень: `InfoWidget(icon: Icons.error, iconAnimationEffect: ShakeEffect())`
- Инлайн: `Text(message, style: textScheme.label.copyWith(color: colorScheme.error))`
- Никогда не выбрасывать ошибку без визуального fallback

### 10.3 Empty

- `InfoWidget(icon: ..., text: ...)`, обёрнутый в `Center`
- Текст: `textScheme.headline`, цвет `surfaceDim.withAlpha(170)`
- Опциональная action-кнопка: `TextButton`

### 10.4 Disabled

- Цвет: `onSurfaceVariant` (не ниже)
- `onTap: null` → `InkWell` не реагирует
- Switch: передать `onChanged: null`
- Не скрывать элемент — делать его неактивным визуально

---

## 11. Паттерны интерактивности

### 11.1 Нажимаемые элементы

Все нажимаемые элементы используют `Material` + `InkWell`:
```
Material(color: backgroundColor, borderRadius: ...)
  └── InkWell(onTap: ..., borderRadius: ...)
        └── [content]
```

Никаких `GestureDetector` для навигационных / toggle-элементов.  
`GestureDetector` допустим только для кастомных drag/scale-жестов.

### 11.2 Hover/Press оверлеи

- `hoverOverlay`: `#0D000000` (5%) светлая, `#14000000` (8%) тёмная
- `pressedOverlay`: `#1A000000` (10%) светлая, `#21000000` (13%) тёмная
- Управляются системой через `InkWell` — не задаются вручную

### 11.3 Анимации цвета

Использовать `TweenAnimationBuilder<Color?>` с `ColorTween` для плавного перехода цветов в интерактивных элементах (150–220ms, `easeOutCubic`).

---

## 12. Иконки

- Библиотека: Material Icons (`Icons.*`)
- Размеры: 16px (мелкие inline), 18px (тайлы настроек), 20px (стандарт), 24px (навигация), 65px (InfoWidget)
- Цвет иконок в списках: `onSurfaceVariant`
- Цвет иконок активного состояния: `onSurface` или `primary`
- Деструктивная иконка: `error`

---

## 13. Разделители

- `Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant)` — стандарт
- `VerticalDivider(width: 1, thickness: 1, color: colorScheme.outlineVariant)` — вертикальный
- `indent: 16` — в группах настроек
- `indent: 56` — в списках с иконкой (отступ после иконки)
- Никогда не использовать `Box` с `border: Border(bottom: ...)` вместо `Divider`

---

## 14. Аватар пользователя — `CompanionAvatar`

- Всегда `BoxShape.circle`
- Рамка: `outlineVariant`, 1px
- Без URL: генерируется градиент из `HSL`-цвета на основе хеша строки
- Инициалы: белый, `w700`, 1–2 символа (автоматически до 2 символов)
- Стандартный размер в тайлах: 40px
- Компактный (сайдбар): 40px
- Расширенный (профиль-карточка): 40–48px

---

## 15. Правила построения экранов новых фич

1. **Изучи контекст:** какие данные отображаются, какие действия доступны.
2. **Определи иерархию:** 1–2 уровня (заголовок → список или заголовок → секции → элементы).
3. **Выбери компоновку:**
   - Список → `ListView.builder` с `CompanionAvatar`-тайлами
   - Форма → `SingleChildScrollView` → `Column` с `CustomTextField`
   - Настройки → `SingleChildScrollView` → `Column` с `SettingsGroupCard`
   - Двухпанельный → `LayoutBuilder` → `Row` (sidebar + content)
4. **Определи состояния:** loading / error / empty / loaded. Каждое из них обязательно.
5. **Используй токены:** только `context.colorScheme`, `context.textScheme`, `context.designTokens`.
6. **Не создавай новые компоненты**, если задача решается существующими.
7. **Анимации:** только `fast` (150ms) или `medium` (250ms), кривые `easeOut`/`easeOutCubic`.
8. **Адаптивность:** проверяй на `constraints.maxWidth < 600` для компактного режима.
9. **Не более одного `AppPrimaryButton` в видимой зоне.**
10. **Деструктивные действия** → красный (`error`), всегда в конце списка/группы, часто с предупреждающей `SettingsInfoCard` рядом.

---

## 16. Структура файлов фичи

```
features/<feature>/
  ├── domain/
  │     ├── models/
  │     ├── interactors/
  │     └── repositories/
  ├── data/
  │     └── repositories/
  └── presentation/
        ├── blocs/           ← Cubit + State
        ├── components/      ← компоненты данной фичи
        ├── screens/         ← основные экраны (entry point)
        └── subfeatures/
              └── <subfeature>/
                    └── presentation/
                          ├── blocs/
                          ├── components/
                          └── screens/
```

Общие компоненты, используемые в двух и более фичах → `core/presentation/components/`.  
Компоненты дизайн-системы (кнопки, поля ввода, типографика) → `uikit/`.

---

## 17. Расширения контекста — обязательные вызовы

| Что нужно | Как получить |
|---|---|
| Цвета | `final colorScheme = context.colorScheme;` |
| Типографика | `final textScheme = context.textScheme;` |
| Локализация | `final l10n = context.l10n;` |
| Токены (spacing, radii) | `final tokens = context.designTokens;` |
| Только радиусы | `final radii = context.radii;` |
| Только рамки | `final borders = context.borders;` |
| Код языка | `context.languageCode` |

**Нельзя:** `Theme.of(context)`, `MediaQuery.textScaleFactorOf(context)` напрямую без необходимости, `TextStyle(fontSize: 14)` без токена.

---

## 18. Свод ограничений (нельзя никогда)

| Запрещено | Причина |
|---|---|
| `color.withOpacity(x)` | Использовать `withAlpha(int)` |
| `Theme.of(context).colorScheme` | Использовать `context.colorScheme` |
| `Widget buildSomething()` | Создать отдельный `StatelessWidget` |
| `children: <Widget>[...]` | Убрать тип, писать просто `children: [...]` |
| Хардкод `fontSize`, `width`, `height` | Только токены или вычисленные значения |
| `GestureDetector` для обычных tap | Использовать `Material` + `InkWell` |
| `bounce`/`elastic` анимации | Только `easeOut`, `easeOutCubic`, `easeInOut` |
| Цветные акценты (синий, зелёный) | Только оттенки серого из `AppColorScheme` |
| Видимые рамки у TextField | Рамки только при `errorText != null` |
| Несколько `AppPrimaryButton` на одном экране | Один CTA в видимой зоне |
