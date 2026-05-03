// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(version) => "Версия ${version}";

  static String m1(count) => "${count} подписчиков";

  static String m2(count) => "${count} участников";

  static String m3(count) => "${count} мин.";

  static String m4(min) => "Не менее ${min} символов";

  static String m5(size) => "${size} в кеше";

  static String m6(size) => "${size} всего в кеше";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutApp": MessageLookupByLibrary.simpleMessage("О приложении"),
    "accountStatus": MessageLookupByLibrary.simpleMessage("Статус аккаунта"),
    "alreadyRegisteredQuestion": MessageLookupByLibrary.simpleMessage(
      "Уже зарегистрированы?",
    ),
    "apiForbiddenException": MessageLookupByLibrary.simpleMessage(
      "Доступ запрещён, у вас нет прав для выполнения этого действия",
    ),
    "apiNotFoundException": MessageLookupByLibrary.simpleMessage(
      "Запрашиваемый ресурс не найден",
    ),
    "apiServerException": MessageLookupByLibrary.simpleMessage(
      "Ошибка сервера, попробуйте позже",
    ),
    "apiTimeoutException": MessageLookupByLibrary.simpleMessage(
      "Время ожидания запроса истекло, повторите попытку",
    ),
    "apiUnauthorizedException": MessageLookupByLibrary.simpleMessage(
      "Ошибка авторизации, пожалуйста, войдите снова",
    ),
    "apiValidationException": MessageLookupByLibrary.simpleMessage(
      "Ошибка валидации данных, проверьте введённую информацию",
    ),
    "appException": MessageLookupByLibrary.simpleMessage(
      "Произошла ошибка приложения",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("Locnet"),
    "appUnknownException": MessageLookupByLibrary.simpleMessage(
      "Произошла неизвестная ошибка",
    ),
    "appVersionDisplay": m0,
    "appVersionUnknown": MessageLookupByLibrary.simpleMessage("Неизвестно"),
    "appearance": MessageLookupByLibrary.simpleMessage("Внешний вид"),
    "apply": MessageLookupByLibrary.simpleMessage("Применить"),
    "authException": MessageLookupByLibrary.simpleMessage("Ошибка авторизации"),
    "authInvalidCredentialsException": MessageLookupByLibrary.simpleMessage(
      "Неверные учетные данные, проверьте логин или пароль",
    ),
    "authLoginAlreadyTakenException": MessageLookupByLibrary.simpleMessage(
      "Этот логин уже занят",
    ),
    "authUnauthorizedException": MessageLookupByLibrary.simpleMessage(
      "Вы не авторизованы, пожалуйста, войдите снова",
    ),
    "authorization": MessageLookupByLibrary.simpleMessage("Авторизация"),
    "back": MessageLookupByLibrary.simpleMessage("Назад"),
    "blockCompanion": MessageLookupByLibrary.simpleMessage("Заблокировать"),
    "brightnessTitle": MessageLookupByLibrary.simpleMessage(
      "Светлая / тёмная тема",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "channelMenuLeave": MessageLookupByLibrary.simpleMessage("Покинуть канал"),
    "channelMenuViewInfo": MessageLookupByLibrary.simpleMessage(
      "Информация о канале",
    ),
    "channelSubscribersCount": m1,
    "charactersCountViolationException": MessageLookupByLibrary.simpleMessage(
      "Недопустимое количество символов",
    ),
    "chats": MessageLookupByLibrary.simpleMessage("Чаты"),
    "chooseHowTheAppLooks": MessageLookupByLibrary.simpleMessage(
      "Выберите облик приложения",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Очистить"),
    "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
    "colorSchemeBlue": MessageLookupByLibrary.simpleMessage("Синий"),
    "colorSchemeDefault": MessageLookupByLibrary.simpleMessage("По умолчанию"),
    "colorSchemeGreen": MessageLookupByLibrary.simpleMessage("Зелёный"),
    "colorSchemePurple": MessageLookupByLibrary.simpleMessage("Фиолетовый"),
    "colorSchemeTitle": MessageLookupByLibrary.simpleMessage(
      "Цветовое оформление",
    ),
    "companionActionCall": MessageLookupByLibrary.simpleMessage("Звонок"),
    "companionActionMessage": MessageLookupByLibrary.simpleMessage("Написать"),
    "companionActionVideo": MessageLookupByLibrary.simpleMessage("Видео"),
    "companionFieldAbout": MessageLookupByLibrary.simpleMessage("О себе"),
    "companionFieldLanguage": MessageLookupByLibrary.simpleMessage("Язык"),
    "companionStatusOffline": MessageLookupByLibrary.simpleMessage("Не в сети"),
    "companionStatusOnline": MessageLookupByLibrary.simpleMessage("В сети"),
    "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "conversationCreating": MessageLookupByLibrary.simpleMessage(
      "Создание переписки",
    ),
    "conversationDescription": MessageLookupByLibrary.simpleMessage("Описание"),
    "conversationNoMessagesYet": MessageLookupByLibrary.simpleMessage(
      "Пока нет сообщений",
    ),
    "conversationTitle": MessageLookupByLibrary.simpleMessage("Название"),
    "conversationType": MessageLookupByLibrary.simpleMessage("Тип"),
    "conversationTypeChannel": MessageLookupByLibrary.simpleMessage("Канал"),
    "conversationTypeChannelHint": MessageLookupByLibrary.simpleMessage(
      "Используется для публикации сообщений. Обычно писать могут только выбранные пользователи, остальные — читать.",
    ),
    "conversationTypeGroup": MessageLookupByLibrary.simpleMessage("Группа"),
    "conversationTypeGroupHint": MessageLookupByLibrary.simpleMessage(
      "Подходит для совместного общения пользователей. Все участники могут отправлять сообщения и видеть историю переписки.",
    ),
    "conversationTypePrivate": MessageLookupByLibrary.simpleMessage("Личная"),
    "conversations": MessageLookupByLibrary.simpleMessage("Переписки"),
    "conversationsListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Кнопками выше можно создать новую переписку или найти людей и чаты.",
    ),
    "conversationsListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Пока нет переписок",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Создать"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Создать аккаунт"),
    "currentSession": MessageLookupByLibrary.simpleMessage("Текущая сессия"),
    "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
    "deleteConversation": MessageLookupByLibrary.simpleMessage(
      "Удалить переписку",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Описание"),
    "deviceThemeMode": MessageLookupByLibrary.simpleMessage(
      "Как на устройстве",
    ),
    "draftChatHint": MessageLookupByLibrary.simpleMessage(
      "Отправьте сообщение, чтобы начать чат",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
    "edited": MessageLookupByLibrary.simpleMessage("Изменено"),
    "emojiCategoryActivities": MessageLookupByLibrary.simpleMessage("Занятия"),
    "emojiCategoryFlags": MessageLookupByLibrary.simpleMessage("Флаги"),
    "emojiCategoryFoodAndDrink": MessageLookupByLibrary.simpleMessage(
      "Еда и напитки",
    ),
    "emojiCategoryNature": MessageLookupByLibrary.simpleMessage(
      "Природа и животные",
    ),
    "emojiCategoryObjects": MessageLookupByLibrary.simpleMessage("Объекты"),
    "emojiCategoryRecent": MessageLookupByLibrary.simpleMessage("Недавние"),
    "emojiCategorySmileysAndPeople": MessageLookupByLibrary.simpleMessage(
      "Смайлы и люди",
    ),
    "emojiCategorySymbols": MessageLookupByLibrary.simpleMessage("Символы"),
    "emojiCategoryTravelAndPlaces": MessageLookupByLibrary.simpleMessage(
      "Путешествия и места",
    ),
    "emojiSearchResults": MessageLookupByLibrary.simpleMessage(
      "Результаты поиска",
    ),
    "filters": MessageLookupByLibrary.simpleMessage("Фильтры"),
    "firstName": MessageLookupByLibrary.simpleMessage("Имя"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Забыли пароль?"),
    "groupMenuDelete": MessageLookupByLibrary.simpleMessage("Удалить группу"),
    "groupMenuLeave": MessageLookupByLibrary.simpleMessage("Покинуть группу"),
    "groupMenuViewInfo": MessageLookupByLibrary.simpleMessage(
      "Информация о группе",
    ),
    "groupParticipantsCount": m2,
    "homePage": MessageLookupByLibrary.simpleMessage("Домашняя страница"),
    "invalidCharactersException": MessageLookupByLibrary.simpleMessage(
      "Введены некорректные символы",
    ),
    "jobPosition": MessageLookupByLibrary.simpleMessage("Должность"),
    "joinedAt": MessageLookupByLibrary.simpleMessage("Дата присоединения"),
    "language": MessageLookupByLibrary.simpleMessage("Язык"),
    "lastName": MessageLookupByLibrary.simpleMessage("Фамилия"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage(
      "Дата последнего обновления",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Загрузка"),
    "logOut": MessageLookupByLibrary.simpleMessage("Выход"),
    "logOutConfirmation": MessageLookupByLibrary.simpleMessage(
      "Вы действительно хотите выйти?",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Логин"),
    "logout": MessageLookupByLibrary.simpleMessage("Выйти"),
    "mediaOpenExternally": MessageLookupByLibrary.simpleMessage(
      "Открыть во внешнем приложении",
    ),
    "mediaVideoLoadFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось загрузить видео",
    ),
    "message": MessageLookupByLibrary.simpleMessage("Сообщение"),
    "messageContextActionCopyText": MessageLookupByLibrary.simpleMessage(
      "Скопировать текст",
    ),
    "messageContextActionDelete": MessageLookupByLibrary.simpleMessage(
      "Удалить",
    ),
    "messageContextActionForward": MessageLookupByLibrary.simpleMessage(
      "Переслать",
    ),
    "messageContextActionReply": MessageLookupByLibrary.simpleMessage(
      "Ответить",
    ),
    "messageContextActionSelect": MessageLookupByLibrary.simpleMessage(
      "Выбрать",
    ),
    "messageInputToolbarActionCopy": MessageLookupByLibrary.simpleMessage(
      "Скопировать",
    ),
    "messageInputToolbarActionCut": MessageLookupByLibrary.simpleMessage(
      "Вырезать",
    ),
    "messageInputToolbarActionDelete": MessageLookupByLibrary.simpleMessage(
      "Удалить",
    ),
    "messageInputToolbarActionFormatBold": MessageLookupByLibrary.simpleMessage(
      "Жирный",
    ),
    "messageInputToolbarActionFormatCode": MessageLookupByLibrary.simpleMessage(
      "Моноширинный",
    ),
    "messageInputToolbarActionFormatCodeBlock":
        MessageLookupByLibrary.simpleMessage("Код"),
    "messageInputToolbarActionFormatItalic":
        MessageLookupByLibrary.simpleMessage("Курсив"),
    "messageInputToolbarActionFormatLink": MessageLookupByLibrary.simpleMessage(
      "Ссылка",
    ),
    "messageInputToolbarActionFormatStrike":
        MessageLookupByLibrary.simpleMessage("Зачёркнутый"),
    "messageInputToolbarActionFormatUnderline":
        MessageLookupByLibrary.simpleMessage("Подчёркнутый"),
    "meta": MessageLookupByLibrary.simpleMessage("Мета"),
    "next": MessageLookupByLibrary.simpleMessage("Далее"),
    "noLabel": MessageLookupByLibrary.simpleMessage("Нет"),
    "notRegisteredYetQuestion": MessageLookupByLibrary.simpleMessage(
      "Не зарегистрированы?",
    ),
    "notSpecified": MessageLookupByLibrary.simpleMessage("Не задано"),
    "nothingFound": MessageLookupByLibrary.simpleMessage("Ничего не найдено"),
    "ok": MessageLookupByLibrary.simpleMessage("ОК"),
    "passcode15Minutes": MessageLookupByLibrary.simpleMessage("15 минут"),
    "passcode1Hour": MessageLookupByLibrary.simpleMessage("1 час"),
    "passcode1Minute": MessageLookupByLibrary.simpleMessage("1 минута"),
    "passcode30Minutes": MessageLookupByLibrary.simpleMessage("30 минут"),
    "passcode5Minutes": MessageLookupByLibrary.simpleMessage("5 минут"),
    "passcodeAppLock": MessageLookupByLibrary.simpleMessage(
      "Блокировка приложения",
    ),
    "passcodeChange": MessageLookupByLibrary.simpleMessage("Сменить PIN"),
    "passcodeChangeTitle": MessageLookupByLibrary.simpleMessage("Смена PIN"),
    "passcodeConfirmPin": MessageLookupByLibrary.simpleMessage("Повторите PIN"),
    "passcodeCurrentPin": MessageLookupByLibrary.simpleMessage("Текущий PIN"),
    "passcodeDisableTitle": MessageLookupByLibrary.simpleMessage(
      "Отключить блокировку",
    ),
    "passcodeEnterPin": MessageLookupByLibrary.simpleMessage("Введите PIN"),
    "passcodeImmediate": MessageLookupByLibrary.simpleMessage("Немедленно"),
    "passcodeLockAfter": MessageLookupByLibrary.simpleMessage(
      "Блокировать через",
    ),
    "passcodeLogOut": MessageLookupByLibrary.simpleMessage("Выйти из аккаунта"),
    "passcodeMinutesCount": m3,
    "passcodeNever": MessageLookupByLibrary.simpleMessage("Никогда"),
    "passcodePinsMismatch": MessageLookupByLibrary.simpleMessage(
      "PIN не совпадает. Попробуйте снова.",
    ),
    "passcodeSectionTitle": MessageLookupByLibrary.simpleMessage("Код доступа"),
    "passcodeSetupTitle": MessageLookupByLibrary.simpleMessage("Установка PIN"),
    "passcodeUnlockButton": MessageLookupByLibrary.simpleMessage(
      "Разблокировать",
    ),
    "passcodeUnlockTitle": MessageLookupByLibrary.simpleMessage(
      "Введите PIN, чтобы продолжить",
    ),
    "passcodeWrongPin": MessageLookupByLibrary.simpleMessage("Неверный PIN"),
    "password": MessageLookupByLibrary.simpleMessage("Пароль"),
    "passwordRequirementAllowedChars": MessageLookupByLibrary.simpleMessage(
      "Допустимы только буквы, цифры и спец. символы",
    ),
    "passwordRequirementDigit": MessageLookupByLibrary.simpleMessage(
      "Хотя бы одна цифра (0–9)",
    ),
    "passwordRequirementLowercase": MessageLookupByLibrary.simpleMessage(
      "Хотя бы одна строчная буква (a–z)",
    ),
    "passwordRequirementMinLength": m4,
    "passwordRequirementSpecial": MessageLookupByLibrary.simpleMessage(
      "Хотя бы один специальный символ (!?@#\$%^&*()_-{})",
    ),
    "passwordRequirementUppercase": MessageLookupByLibrary.simpleMessage(
      "Хотя бы одна заглавная буква (A–Z)",
    ),
    "passwordRequirementsTitle": MessageLookupByLibrary.simpleMessage(
      "Требования к паролю",
    ),
    "passwordTooWeakException": MessageLookupByLibrary.simpleMessage(
      "Пароль слишком слабый",
    ),
    "passwordsMismatchException": MessageLookupByLibrary.simpleMessage(
      "Пароли не совпадают",
    ),
    "personalInformation": MessageLookupByLibrary.simpleMessage(
      "Личная информация",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "profileChangePhoto": MessageLookupByLibrary.simpleMessage("Сменить фото"),
    "profileEditing": MessageLookupByLibrary.simpleMessage(
      "Редактирование профиля",
    ),
    "registration": MessageLookupByLibrary.simpleMessage("Регистрация"),
    "repeatPassword": MessageLookupByLibrary.simpleMessage("Повторите пароль"),
    "requiredValueNotProvidedException": MessageLookupByLibrary.simpleMessage(
      "Обязательно для заполнения",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Сбросить"),
    "retry": MessageLookupByLibrary.simpleMessage("Попробовать снова"),
    "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "search": MessageLookupByLibrary.simpleMessage("Поиск"),
    "searchEmoji": MessageLookupByLibrary.simpleMessage("Поиск эмодзи"),
    "searchUsersAndChatsHint": MessageLookupByLibrary.simpleMessage(
      "Введите имя пользователя или название группы/канала.",
    ),
    "selectConversation": MessageLookupByLibrary.simpleMessage("Выберите чат"),
    "selectConversationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Выберите пользователя, группу или канал, чтобы начать переписку",
    ),
    "selectInterfaceLanguage": MessageLookupByLibrary.simpleMessage(
      "Выберите язык интерфейса",
    ),
    "sessionAccessExpiresAt": MessageLookupByLibrary.simpleMessage(
      "Истекает access-токен",
    ),
    "sessionCreatedAt": MessageLookupByLibrary.simpleMessage("Создана"),
    "sessionDetails": MessageLookupByLibrary.simpleMessage("Детали сессии"),
    "sessionDeviceName": MessageLookupByLibrary.simpleMessage("Имя устройства"),
    "sessionDeviceType": MessageLookupByLibrary.simpleMessage("Тип устройства"),
    "sessionExpiresAt": MessageLookupByLibrary.simpleMessage("Истекает"),
    "sessionIpAddress": MessageLookupByLibrary.simpleMessage("IP-адрес"),
    "sessionIsExpired": MessageLookupByLibrary.simpleMessage("Истекла"),
    "sessionIsNotLoadedYet": MessageLookupByLibrary.simpleMessage(
      "Данные о сессии ещё не загружены. Попробуйте ещё раз",
    ),
    "sessionIsTerminated": MessageLookupByLibrary.simpleMessage("Завершена"),
    "sessionMacAddress": MessageLookupByLibrary.simpleMessage("MAC-адрес"),
    "sessionOs": MessageLookupByLibrary.simpleMessage("ОС"),
    "sessionRefreshExpiresAt": MessageLookupByLibrary.simpleMessage(
      "Истекает refresh-токен",
    ),
    "sessionSessionId": MessageLookupByLibrary.simpleMessage("ID сессии"),
    "sessionStatusActive": MessageLookupByLibrary.simpleMessage("Активна"),
    "sessionStatusExpired": MessageLookupByLibrary.simpleMessage("Истекла"),
    "sessionStatusTerminated": MessageLookupByLibrary.simpleMessage(
      "Завершена",
    ),
    "sessionTerminatedAt": MessageLookupByLibrary.simpleMessage("Завершена"),
    "sessionUpdatedAt": MessageLookupByLibrary.simpleMessage("Обновлена"),
    "sessionUserId": MessageLookupByLibrary.simpleMessage("ID пользователя"),
    "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
    "settingsAccentSection": MessageLookupByLibrary.simpleMessage("Акцент"),
    "settingsAllowPush": MessageLookupByLibrary.simpleMessage(
      "Push-уведомления",
    ),
    "settingsAppVersionTitle": MessageLookupByLibrary.simpleMessage("Сборка"),
    "settingsAutoScroll": MessageLookupByLibrary.simpleMessage(
      "Прокрутка к новым",
    ),
    "settingsChatBehaviorSection": MessageLookupByLibrary.simpleMessage(
      "Поведение",
    ),
    "settingsChats": MessageLookupByLibrary.simpleMessage("Настройки чатов"),
    "settingsChatsAppearance": MessageLookupByLibrary.simpleMessage(
      "Внешний вид",
    ),
    "settingsChatsShortcuts": MessageLookupByLibrary.simpleMessage(
      "Сочетания клавиш",
    ),
    "settingsChatsShortcutsDescription": MessageLookupByLibrary.simpleMessage(
      "Сочетания клавиш будут доступны в следующем обновлении.",
    ),
    "settingsDoNotDisturb": MessageLookupByLibrary.simpleMessage(
      "Не беспокоить",
    ),
    "settingsDynamicTheme": MessageLookupByLibrary.simpleMessage(
      "Динамическая тема",
    ),
    "settingsDynamicThemeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Подстроить цвета под обои",
    ),
    "settingsElementScale": MessageLookupByLibrary.simpleMessage(
      "Масштаб элементов",
    ),
    "settingsInterfaceSection": MessageLookupByLibrary.simpleMessage(
      "Интерфейс",
    ),
    "settingsLanguage": MessageLookupByLibrary.simpleMessage("Язык"),
    "settingsLoading": MessageLookupByLibrary.simpleMessage(
      "Загрузка настроек…",
    ),
    "settingsMyProfile": MessageLookupByLibrary.simpleMessage("Мой профиль"),
    "settingsMyProfileDescription": MessageLookupByLibrary.simpleMessage(
      "Просмотр и редактирование профиля",
    ),
    "settingsNotificationSoundTone": MessageLookupByLibrary.simpleMessage(
      "Мелодия",
    ),
    "settingsNotificationsAndSounds": MessageLookupByLibrary.simpleMessage(
      "Уведомления и звуки",
    ),
    "settingsNotificationsPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Настройка уведомлений и звуков",
    ),
    "settingsNotifyMentions": MessageLookupByLibrary.simpleMessage(
      "Упоминания",
    ),
    "settingsNotifySystem": MessageLookupByLibrary.simpleMessage("Системные"),
    "settingsPreviewLabel": MessageLookupByLibrary.simpleMessage(
      "Предпросмотр",
    ),
    "settingsPrivacy": MessageLookupByLibrary.simpleMessage(
      "Конфиденциальность",
    ),
    "settingsPrivacyPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Сессия и безопасность",
    ),
    "settingsPrivacyTimingSection": MessageLookupByLibrary.simpleMessage(
      "Срок действия сессии",
    ),
    "settingsPushSection": MessageLookupByLibrary.simpleMessage("Push"),
    "settingsSaveDrafts": MessageLookupByLibrary.simpleMessage("Черновики"),
    "settingsSendOnEnter": MessageLookupByLibrary.simpleMessage(
      "Отправка по Enter",
    ),
    "settingsSendOnEnterSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enter отправляет; Shift+Enter — новая строка ниже",
    ),
    "settingsShiftEnterNewLine": MessageLookupByLibrary.simpleMessage(
      "Shift+Enter — новая строка",
    ),
    "settingsSound": MessageLookupByLibrary.simpleMessage("Звук"),
    "settingsSoundChime": MessageLookupByLibrary.simpleMessage("Звонок"),
    "settingsSoundDefault": MessageLookupByLibrary.simpleMessage("Стандарт"),
    "settingsSoundNewMessages": MessageLookupByLibrary.simpleMessage(
      "Входящие сообщения",
    ),
    "settingsSoundPing": MessageLookupByLibrary.simpleMessage("Пинг"),
    "settingsSoundSend": MessageLookupByLibrary.simpleMessage("Отправка"),
    "settingsSoundSystem": MessageLookupByLibrary.simpleMessage(
      "Системные звуки",
    ),
    "settingsSoundsSection": MessageLookupByLibrary.simpleMessage("Звуки"),
    "settingsStorageActions": MessageLookupByLibrary.simpleMessage("Действия"),
    "settingsStorageAlreadyEmpty": MessageLookupByLibrary.simpleMessage(
      "Кеш уже пуст.",
    ),
    "settingsStorageAudio": MessageLookupByLibrary.simpleMessage("Аудио"),
    "settingsStorageByType": MessageLookupByLibrary.simpleMessage(
      "По типу данных",
    ),
    "settingsStorageCacheEmpty": MessageLookupByLibrary.simpleMessage(
      "Кеш пуст",
    ),
    "settingsStorageCacheEmptyHint": MessageLookupByLibrary.simpleMessage(
      "Данные не кешированы локально.",
    ),
    "settingsStorageCached": m5,
    "settingsStorageClearAll": MessageLookupByLibrary.simpleMessage(
      "Очистить кеш",
    ),
    "settingsStorageClearAllBody": MessageLookupByLibrary.simpleMessage(
      "Все кешированные чаты, сообщения и данные медиа будут удалены. Это действие необратимо.",
    ),
    "settingsStorageClearAllTitle": MessageLookupByLibrary.simpleMessage(
      "Очистить кеш",
    ),
    "settingsStorageClearCacheHint": MessageLookupByLibrary.simpleMessage(
      "Очистка кеша не удалит сообщения или медиафайлы с сервера.",
    ),
    "settingsStorageMessages": MessageLookupByLibrary.simpleMessage(
      "Сообщения",
    ),
    "settingsStorageOtherFiles": MessageLookupByLibrary.simpleMessage(
      "Другие файлы",
    ),
    "settingsStoragePhotos": MessageLookupByLibrary.simpleMessage("Фотографии"),
    "settingsStorageSection": MessageLookupByLibrary.simpleMessage("Хранилище"),
    "settingsStorageTotalCached": m6,
    "settingsStorageVideos": MessageLookupByLibrary.simpleMessage("Видео"),
    "settingsTextScale": MessageLookupByLibrary.simpleMessage("Размер текста"),
    "settingsThemeModeLabel": MessageLookupByLibrary.simpleMessage("Режим"),
    "settingsThemeSection": MessageLookupByLibrary.simpleMessage("Тема"),
    "share": MessageLookupByLibrary.simpleMessage("Поделиться"),
    "signIn": MessageLookupByLibrary.simpleMessage("Войти"),
    "storage": MessageLookupByLibrary.simpleMessage("Хранилище"),
    "storageException": MessageLookupByLibrary.simpleMessage(
      "Ошибка хранилища",
    ),
    "storageIOException": MessageLookupByLibrary.simpleMessage(
      "Ошибка чтения/записи в хранилище",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Тема"),
    "themeModeDark": MessageLookupByLibrary.simpleMessage("Тёмная"),
    "themeModeLight": MessageLookupByLibrary.simpleMessage("Светлая"),
    "themeModeSystem": MessageLookupByLibrary.simpleMessage("Системная"),
    "toggleNotificationsOff": MessageLookupByLibrary.simpleMessage(
      "Выключить уведомления",
    ),
    "toggleNotificationsOn": MessageLookupByLibrary.simpleMessage(
      "Включить уведомления",
    ),
    "tryAnotherQuery": MessageLookupByLibrary.simpleMessage(
      "Попробуйте изменить запрос",
    ),
    "unknownValue": MessageLookupByLibrary.simpleMessage("Неизвестно"),
    "username": MessageLookupByLibrary.simpleMessage("Юзернейм"),
    "users": MessageLookupByLibrary.simpleMessage("Пользователи"),
    "yesLabel": MessageLookupByLibrary.simpleMessage("Да"),
    "you": MessageLookupByLibrary.simpleMessage("Вы"),
  };
}
