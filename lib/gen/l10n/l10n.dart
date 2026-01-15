// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `ОК`
  String get ok {
    return Intl.message('ОК', name: 'ok', desc: '', args: []);
  }

  /// `Отмена`
  String get cancel {
    return Intl.message('Отмена', name: 'cancel', desc: '', args: []);
  }

  /// `Закрыть`
  String get close {
    return Intl.message('Закрыть', name: 'close', desc: '', args: []);
  }

  /// `Сохранить`
  String get save {
    return Intl.message('Сохранить', name: 'save', desc: '', args: []);
  }

  /// `Редактировать`
  String get edit {
    return Intl.message('Редактировать', name: 'edit', desc: '', args: []);
  }

  /// `Удалить`
  String get delete {
    return Intl.message('Удалить', name: 'delete', desc: '', args: []);
  }

  /// `Назад`
  String get back {
    return Intl.message('Назад', name: 'back', desc: '', args: []);
  }

  /// `Далее`
  String get next {
    return Intl.message('Далее', name: 'next', desc: '', args: []);
  }

  /// `Подтвердить`
  String get confirm {
    return Intl.message('Подтвердить', name: 'confirm', desc: '', args: []);
  }

  /// `Применить`
  String get apply {
    return Intl.message('Применить', name: 'apply', desc: '', args: []);
  }

  /// `Сбросить`
  String get reset {
    return Intl.message('Сбросить', name: 'reset', desc: '', args: []);
  }

  /// `Очистить`
  String get clear {
    return Intl.message('Очистить', name: 'clear', desc: '', args: []);
  }

  /// `Поделиться`
  String get share {
    return Intl.message('Поделиться', name: 'share', desc: '', args: []);
  }

  /// `Настройки`
  String get settings {
    return Intl.message('Настройки', name: 'settings', desc: '', args: []);
  }

  /// `Язык`
  String get language {
    return Intl.message('Язык', name: 'language', desc: '', args: []);
  }

  /// `Тема`
  String get themeMode {
    return Intl.message('Тема', name: 'themeMode', desc: '', args: []);
  }

  /// `Системная`
  String get themeModeSystem {
    return Intl.message(
      'Системная',
      name: 'themeModeSystem',
      desc: '',
      args: [],
    );
  }

  /// `Светлая`
  String get themeModeLight {
    return Intl.message('Светлая', name: 'themeModeLight', desc: '', args: []);
  }

  /// `Тёмная`
  String get themeModeDark {
    return Intl.message('Тёмная', name: 'themeModeDark', desc: '', args: []);
  }

  /// `Как на устройстве`
  String get deviceThemeMode {
    return Intl.message(
      'Как на устройстве',
      name: 'deviceThemeMode',
      desc: '',
      args: [],
    );
  }

  /// `Попробовать снова`
  String get retry {
    return Intl.message('Попробовать снова', name: 'retry', desc: '', args: []);
  }

  /// `Произошла ошибка приложения`
  String get appException {
    return Intl.message(
      'Произошла ошибка приложения',
      name: 'appException',
      desc: '',
      args: [],
    );
  }

  /// `Произошла неизвестная ошибка`
  String get appUnknownException {
    return Intl.message(
      'Произошла неизвестная ошибка',
      name: 'appUnknownException',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка авторизации, пожалуйста, войдите снова`
  String get apiUnauthorizedException {
    return Intl.message(
      'Ошибка авторизации, пожалуйста, войдите снова',
      name: 'apiUnauthorizedException',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка сервера, попробуйте позже`
  String get apiServerException {
    return Intl.message(
      'Ошибка сервера, попробуйте позже',
      name: 'apiServerException',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка валидации данных, проверьте введённую информацию`
  String get apiValidationException {
    return Intl.message(
      'Ошибка валидации данных, проверьте введённую информацию',
      name: 'apiValidationException',
      desc: '',
      args: [],
    );
  }

  /// `Запрашиваемый ресурс не найден`
  String get apiNotFoundException {
    return Intl.message(
      'Запрашиваемый ресурс не найден',
      name: 'apiNotFoundException',
      desc: '',
      args: [],
    );
  }

  /// `Доступ запрещён, у вас нет прав для выполнения этого действия`
  String get apiForbiddenException {
    return Intl.message(
      'Доступ запрещён, у вас нет прав для выполнения этого действия',
      name: 'apiForbiddenException',
      desc: '',
      args: [],
    );
  }

  /// `Время ожидания запроса истекло, повторите попытку`
  String get apiTimeoutException {
    return Intl.message(
      'Время ожидания запроса истекло, повторите попытку',
      name: 'apiTimeoutException',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка хранилища`
  String get storageException {
    return Intl.message(
      'Ошибка хранилища',
      name: 'storageException',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка чтения/записи в хранилище`
  String get storageIOException {
    return Intl.message(
      'Ошибка чтения/записи в хранилище',
      name: 'storageIOException',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка авторизации`
  String get authException {
    return Intl.message(
      'Ошибка авторизации',
      name: 'authException',
      desc: '',
      args: [],
    );
  }

  /// `Вы не авторизованы, пожалуйста, войдите снова`
  String get authUnauthorizedException {
    return Intl.message(
      'Вы не авторизованы, пожалуйста, войдите снова',
      name: 'authUnauthorizedException',
      desc: '',
      args: [],
    );
  }

  /// `Неверные учетные данные, проверьте логин или пароль`
  String get authInvalidCredentialsException {
    return Intl.message(
      'Неверные учетные данные, проверьте логин или пароль',
      name: 'authInvalidCredentialsException',
      desc: '',
      args: [],
    );
  }

  /// `Введены некорректные символы`
  String get invalidCharactersException {
    return Intl.message(
      'Введены некорректные символы',
      name: 'invalidCharactersException',
      desc: '',
      args: [],
    );
  }

  /// `Недопустимое количество символов`
  String get charactersCountViolationException {
    return Intl.message(
      'Недопустимое количество символов',
      name: 'charactersCountViolationException',
      desc: '',
      args: [],
    );
  }

  /// `Обязательно для заполнения`
  String get requiredValueNotProvidedException {
    return Intl.message(
      'Обязательно для заполнения',
      name: 'requiredValueNotProvidedException',
      desc: '',
      args: [],
    );
  }

  /// `Пароли не совпадают`
  String get passwordsMismatchException {
    return Intl.message(
      'Пароли не совпадают',
      name: 'passwordsMismatchException',
      desc: '',
      args: [],
    );
  }

  /// `Пароль слишком слабый`
  String get passwordTooWeakException {
    return Intl.message(
      'Пароль слишком слабый',
      name: 'passwordTooWeakException',
      desc: '',
      args: [],
    );
  }

  /// `Авторизация`
  String get authorization {
    return Intl.message(
      'Авторизация',
      name: 'authorization',
      desc: '',
      args: [],
    );
  }

  /// `Войти`
  String get signIn {
    return Intl.message('Войти', name: 'signIn', desc: '', args: []);
  }

  /// `Логин`
  String get login {
    return Intl.message('Логин', name: 'login', desc: '', args: []);
  }

  /// `Выйти`
  String get logout {
    return Intl.message('Выйти', name: 'logout', desc: '', args: []);
  }

  /// `Пароль`
  String get password {
    return Intl.message('Пароль', name: 'password', desc: '', args: []);
  }

  /// `Повторите пароль`
  String get repeatPassword {
    return Intl.message(
      'Повторите пароль',
      name: 'repeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Не зарегистрированы?`
  String get registrationQuestion {
    return Intl.message(
      'Не зарегистрированы?',
      name: 'registrationQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Уже зарегистрированы?`
  String get alreadyRegisteredQuestion {
    return Intl.message(
      'Уже зарегистрированы?',
      name: 'alreadyRegisteredQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Регистрация`
  String get registration {
    return Intl.message(
      'Регистрация',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `Имя`
  String get firstName {
    return Intl.message('Имя', name: 'firstName', desc: '', args: []);
  }

  /// `Фамилия`
  String get lastName {
    return Intl.message('Фамилия', name: 'lastName', desc: '', args: []);
  }

  /// `Должность`
  String get jobPosition {
    return Intl.message('Должность', name: 'jobPosition', desc: '', args: []);
  }

  /// `Внешний вид`
  String get appearance {
    return Intl.message('Внешний вид', name: 'appearance', desc: '', args: []);
  }

  /// `Выберите облик приложения`
  String get chooseHowTheAppLooks {
    return Intl.message(
      'Выберите облик приложения',
      name: 'chooseHowTheAppLooks',
      desc: '',
      args: [],
    );
  }

  /// `Выберите язык интерфейса`
  String get selectInterfaceLanguage {
    return Intl.message(
      'Выберите язык интерфейса',
      name: 'selectInterfaceLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Текущая сессия`
  String get currentSession {
    return Intl.message(
      'Текущая сессия',
      name: 'currentSession',
      desc: '',
      args: [],
    );
  }

  /// `Детали сессии`
  String get sessionDetails {
    return Intl.message(
      'Детали сессии',
      name: 'sessionDetails',
      desc: '',
      args: [],
    );
  }

  /// `Да`
  String get yesLabel {
    return Intl.message('Да', name: 'yesLabel', desc: '', args: []);
  }

  /// `Нет`
  String get noLabel {
    return Intl.message('Нет', name: 'noLabel', desc: '', args: []);
  }

  /// `Истекла`
  String get sessionStatusExpired {
    return Intl.message(
      'Истекла',
      name: 'sessionStatusExpired',
      desc: '',
      args: [],
    );
  }

  /// `Активна`
  String get sessionStatusActive {
    return Intl.message(
      'Активна',
      name: 'sessionStatusActive',
      desc: '',
      args: [],
    );
  }

  /// `Завершена`
  String get sessionStatusTerminated {
    return Intl.message(
      'Завершена',
      name: 'sessionStatusTerminated',
      desc: '',
      args: [],
    );
  }

  /// `ID пользователя`
  String get sessionUserId {
    return Intl.message(
      'ID пользователя',
      name: 'sessionUserId',
      desc: '',
      args: [],
    );
  }

  /// `ID сессии`
  String get sessionSessionId {
    return Intl.message(
      'ID сессии',
      name: 'sessionSessionId',
      desc: '',
      args: [],
    );
  }

  /// `Имя устройства`
  String get sessionDeviceName {
    return Intl.message(
      'Имя устройства',
      name: 'sessionDeviceName',
      desc: '',
      args: [],
    );
  }

  /// `Тип устройства`
  String get sessionDeviceType {
    return Intl.message(
      'Тип устройства',
      name: 'sessionDeviceType',
      desc: '',
      args: [],
    );
  }

  /// `ОС`
  String get sessionOs {
    return Intl.message('ОС', name: 'sessionOs', desc: '', args: []);
  }

  /// `IP-адрес`
  String get sessionIpAddress {
    return Intl.message(
      'IP-адрес',
      name: 'sessionIpAddress',
      desc: '',
      args: [],
    );
  }

  /// `MAC-адрес`
  String get sessionMacAddress {
    return Intl.message(
      'MAC-адрес',
      name: 'sessionMacAddress',
      desc: '',
      args: [],
    );
  }

  /// `Создана`
  String get sessionCreatedAt {
    return Intl.message(
      'Создана',
      name: 'sessionCreatedAt',
      desc: '',
      args: [],
    );
  }

  /// `Обновлена`
  String get sessionUpdatedAt {
    return Intl.message(
      'Обновлена',
      name: 'sessionUpdatedAt',
      desc: '',
      args: [],
    );
  }

  /// `Истекает`
  String get sessionExpiresAt {
    return Intl.message(
      'Истекает',
      name: 'sessionExpiresAt',
      desc: '',
      args: [],
    );
  }

  /// `Завершена`
  String get sessionTerminatedAt {
    return Intl.message(
      'Завершена',
      name: 'sessionTerminatedAt',
      desc: '',
      args: [],
    );
  }

  /// `Истекла`
  String get sessionIsExpired {
    return Intl.message(
      'Истекла',
      name: 'sessionIsExpired',
      desc: '',
      args: [],
    );
  }

  /// `Завершена`
  String get sessionIsTerminated {
    return Intl.message(
      'Завершена',
      name: 'sessionIsTerminated',
      desc: '',
      args: [],
    );
  }

  /// `Неизвестно`
  String get unknownValue {
    return Intl.message('Неизвестно', name: 'unknownValue', desc: '', args: []);
  }

  /// `Переписки`
  String get conversations {
    return Intl.message('Переписки', name: 'conversations', desc: '', args: []);
  }

  /// `Хранилище`
  String get storage {
    return Intl.message('Хранилище', name: 'storage', desc: '', args: []);
  }

  /// `Домашняя страница`
  String get homePage {
    return Intl.message(
      'Домашняя страница',
      name: 'homePage',
      desc: '',
      args: [],
    );
  }

  /// `Личная информация`
  String get personalInformation {
    return Intl.message(
      'Личная информация',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Не задано`
  String get notSpecified {
    return Intl.message('Не задано', name: 'notSpecified', desc: '', args: []);
  }

  /// `Статус аккаунта`
  String get accountStatus {
    return Intl.message(
      'Статус аккаунта',
      name: 'accountStatus',
      desc: '',
      args: [],
    );
  }

  /// `Мета`
  String get meta {
    return Intl.message('Мета', name: 'meta', desc: '', args: []);
  }

  /// `Дата присоединения`
  String get joinedAt {
    return Intl.message(
      'Дата присоединения',
      name: 'joinedAt',
      desc: '',
      args: [],
    );
  }

  /// `Дата последнего обновления`
  String get lastUpdated {
    return Intl.message(
      'Дата последнего обновления',
      name: 'lastUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Профиль`
  String get profile {
    return Intl.message('Профиль', name: 'profile', desc: '', args: []);
  }

  /// `Описание`
  String get description {
    return Intl.message('Описание', name: 'description', desc: '', args: []);
  }

  /// `Юзернейм`
  String get username {
    return Intl.message('Юзернейм', name: 'username', desc: '', args: []);
  }

  /// `Редактирование профиля`
  String get profileEditing {
    return Intl.message(
      'Редактирование профиля',
      name: 'profileEditing',
      desc: '',
      args: [],
    );
  }

  /// `Название`
  String get conversationTitle {
    return Intl.message(
      'Название',
      name: 'conversationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Описание`
  String get conversationDescription {
    return Intl.message(
      'Описание',
      name: 'conversationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Тип`
  String get conversationType {
    return Intl.message('Тип', name: 'conversationType', desc: '', args: []);
  }

  /// `Создать`
  String get create {
    return Intl.message('Создать', name: 'create', desc: '', args: []);
  }

  /// `Создание переписки`
  String get conversationCreating {
    return Intl.message(
      'Создание переписки',
      name: 'conversationCreating',
      desc: '',
      args: [],
    );
  }

  /// `Личная`
  String get conversationTypePrivate {
    return Intl.message(
      'Личная',
      name: 'conversationTypePrivate',
      desc: '',
      args: [],
    );
  }

  /// `Группа`
  String get conversationTypeGroup {
    return Intl.message(
      'Группа',
      name: 'conversationTypeGroup',
      desc: '',
      args: [],
    );
  }

  /// `Канал`
  String get conversationTypeChannel {
    return Intl.message(
      'Канал',
      name: 'conversationTypeChannel',
      desc: '',
      args: [],
    );
  }

  /// `Поиск`
  String get search {
    return Intl.message('Поиск', name: 'search', desc: '', args: []);
  }

  /// `Сообщение`
  String get message {
    return Intl.message('Сообщение', name: 'message', desc: '', args: []);
  }

  /// `Заблокировать`
  String get blockCompanion {
    return Intl.message(
      'Заблокировать',
      name: 'blockCompanion',
      desc: '',
      args: [],
    );
  }

  /// `Удалить переписку`
  String get deleteConversation {
    return Intl.message(
      'Удалить переписку',
      name: 'deleteConversation',
      desc: '',
      args: [],
    );
  }

  /// `Включить уведомления`
  String get toggleNotificationsOn {
    return Intl.message(
      'Включить уведомления',
      name: 'toggleNotificationsOn',
      desc: '',
      args: [],
    );
  }

  /// `Выключить уведомления`
  String get toggleNotificationsOff {
    return Intl.message(
      'Выключить уведомления',
      name: 'toggleNotificationsOff',
      desc: '',
      args: [],
    );
  }

  /// `Фильтры`
  String get filters {
    return Intl.message('Фильтры', name: 'filters', desc: '', args: []);
  }

  /// `Изменено`
  String get edited {
    return Intl.message('Изменено', name: 'edited', desc: '', args: []);
  }

  /// `Данные о сессии ещё не загружены. Попробуйте ещё раз`
  String get sessionIsNotLoadedYet {
    return Intl.message(
      'Данные о сессии ещё не загружены. Попробуйте ещё раз',
      name: 'sessionIsNotLoadedYet',
      desc: '',
      args: [],
    );
  }

  /// `Выход`
  String get logOut {
    return Intl.message('Выход', name: 'logOut', desc: '', args: []);
  }

  /// `Вы действительно хотите выйти?`
  String get logOutConfirmation {
    return Intl.message(
      'Вы действительно хотите выйти?',
      name: 'logOutConfirmation',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'uz'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
