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

  /// `Этот логин уже занят`
  String get authLoginAlreadyTakenException {
    return Intl.message(
      'Этот логин уже занят',
      name: 'authLoginAlreadyTakenException',
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

  /// `Забыли пароль?`
  String get forgotPassword {
    return Intl.message(
      'Забыли пароль?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Создать аккаунт`
  String get createAccount {
    return Intl.message(
      'Создать аккаунт',
      name: 'createAccount',
      desc: '',
      args: [],
    );
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
  String get notRegisteredYetQuestion {
    return Intl.message(
      'Не зарегистрированы?',
      name: 'notRegisteredYetQuestion',
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

  /// `Цветовое оформление`
  String get colorSchemeTitle {
    return Intl.message(
      'Цветовое оформление',
      name: 'colorSchemeTitle',
      desc: '',
      args: [],
    );
  }

  /// `По умолчанию`
  String get colorSchemeDefault {
    return Intl.message(
      'По умолчанию',
      name: 'colorSchemeDefault',
      desc: '',
      args: [],
    );
  }

  /// `Синий`
  String get colorSchemeBlue {
    return Intl.message('Синий', name: 'colorSchemeBlue', desc: '', args: []);
  }

  /// `Зелёный`
  String get colorSchemeGreen {
    return Intl.message(
      'Зелёный',
      name: 'colorSchemeGreen',
      desc: '',
      args: [],
    );
  }

  /// `Фиолетовый`
  String get colorSchemePurple {
    return Intl.message(
      'Фиолетовый',
      name: 'colorSchemePurple',
      desc: '',
      args: [],
    );
  }

  /// `Светлая / тёмная тема`
  String get brightnessTitle {
    return Intl.message(
      'Светлая / тёмная тема',
      name: 'brightnessTitle',
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

  /// `Истекает access-токен`
  String get sessionAccessExpiresAt {
    return Intl.message(
      'Истекает access-токен',
      name: 'sessionAccessExpiresAt',
      desc: '',
      args: [],
    );
  }

  /// `Истекает refresh-токен`
  String get sessionRefreshExpiresAt {
    return Intl.message(
      'Истекает refresh-токен',
      name: 'sessionRefreshExpiresAt',
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

  /// `Чат будет удалён из списка. Продолжить?`
  String get deletePrivateConversationBody {
    return Intl.message(
      'Чат будет удалён из списка. Продолжить?',
      name: 'deletePrivateConversationBody',
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

  /// `Скопировать текст`
  String get messageContextActionCopyText {
    return Intl.message(
      'Скопировать текст',
      name: 'messageContextActionCopyText',
      desc: '',
      args: [],
    );
  }

  /// `Удалить`
  String get messageContextActionDelete {
    return Intl.message(
      'Удалить',
      name: 'messageContextActionDelete',
      desc: '',
      args: [],
    );
  }

  /// `Переслать`
  String get messageContextActionForward {
    return Intl.message(
      'Переслать',
      name: 'messageContextActionForward',
      desc: '',
      args: [],
    );
  }

  /// `Выбрать`
  String get messageContextActionSelect {
    return Intl.message(
      'Выбрать',
      name: 'messageContextActionSelect',
      desc: '',
      args: [],
    );
  }

  /// `Ответить`
  String get messageContextActionReply {
    return Intl.message(
      'Ответить',
      name: 'messageContextActionReply',
      desc: '',
      args: [],
    );
  }

  /// `Удалить это сообщение?`
  String get deleteMessageConfirmation {
    return Intl.message(
      'Удалить это сообщение?',
      name: 'deleteMessageConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Удалить выбранные сообщения ({count})?`
  String deleteSelectedMessagesConfirmation(Object count) {
    return Intl.message(
      'Удалить выбранные сообщения ($count)?',
      name: 'deleteSelectedMessagesConfirmation',
      desc: '',
      args: [count],
    );
  }

  /// `Вырезать`
  String get messageInputToolbarActionCut {
    return Intl.message(
      'Вырезать',
      name: 'messageInputToolbarActionCut',
      desc: '',
      args: [],
    );
  }

  /// `Скопировать`
  String get messageInputToolbarActionCopy {
    return Intl.message(
      'Скопировать',
      name: 'messageInputToolbarActionCopy',
      desc: '',
      args: [],
    );
  }

  /// `Удалить`
  String get messageInputToolbarActionDelete {
    return Intl.message(
      'Удалить',
      name: 'messageInputToolbarActionDelete',
      desc: '',
      args: [],
    );
  }

  /// `Жирный`
  String get messageInputToolbarActionFormatBold {
    return Intl.message(
      'Жирный',
      name: 'messageInputToolbarActionFormatBold',
      desc: '',
      args: [],
    );
  }

  /// `Курсив`
  String get messageInputToolbarActionFormatItalic {
    return Intl.message(
      'Курсив',
      name: 'messageInputToolbarActionFormatItalic',
      desc: '',
      args: [],
    );
  }

  /// `Зачёркнутый`
  String get messageInputToolbarActionFormatStrike {
    return Intl.message(
      'Зачёркнутый',
      name: 'messageInputToolbarActionFormatStrike',
      desc: '',
      args: [],
    );
  }

  /// `Моноширинный`
  String get messageInputToolbarActionFormatCode {
    return Intl.message(
      'Моноширинный',
      name: 'messageInputToolbarActionFormatCode',
      desc: '',
      args: [],
    );
  }

  /// `Код`
  String get messageInputToolbarActionFormatCodeBlock {
    return Intl.message(
      'Код',
      name: 'messageInputToolbarActionFormatCodeBlock',
      desc: '',
      args: [],
    );
  }

  /// `Ссылка`
  String get messageInputToolbarActionFormatLink {
    return Intl.message(
      'Ссылка',
      name: 'messageInputToolbarActionFormatLink',
      desc: '',
      args: [],
    );
  }

  /// `Подчёркнутый`
  String get messageInputToolbarActionFormatUnderline {
    return Intl.message(
      'Подчёркнутый',
      name: 'messageInputToolbarActionFormatUnderline',
      desc: '',
      args: [],
    );
  }

  /// `Поиск эмодзи`
  String get searchEmoji {
    return Intl.message(
      'Поиск эмодзи',
      name: 'searchEmoji',
      desc: '',
      args: [],
    );
  }

  /// `Смайлы и люди`
  String get emojiCategorySmileysAndPeople {
    return Intl.message(
      'Смайлы и люди',
      name: 'emojiCategorySmileysAndPeople',
      desc: '',
      args: [],
    );
  }

  /// `Природа и животные`
  String get emojiCategoryNature {
    return Intl.message(
      'Природа и животные',
      name: 'emojiCategoryNature',
      desc: '',
      args: [],
    );
  }

  /// `Еда и напитки`
  String get emojiCategoryFoodAndDrink {
    return Intl.message(
      'Еда и напитки',
      name: 'emojiCategoryFoodAndDrink',
      desc: '',
      args: [],
    );
  }

  /// `Занятия`
  String get emojiCategoryActivities {
    return Intl.message(
      'Занятия',
      name: 'emojiCategoryActivities',
      desc: '',
      args: [],
    );
  }

  /// `Путешествия и места`
  String get emojiCategoryTravelAndPlaces {
    return Intl.message(
      'Путешествия и места',
      name: 'emojiCategoryTravelAndPlaces',
      desc: '',
      args: [],
    );
  }

  /// `Объекты`
  String get emojiCategoryObjects {
    return Intl.message(
      'Объекты',
      name: 'emojiCategoryObjects',
      desc: '',
      args: [],
    );
  }

  /// `Символы`
  String get emojiCategorySymbols {
    return Intl.message(
      'Символы',
      name: 'emojiCategorySymbols',
      desc: '',
      args: [],
    );
  }

  /// `Флаги`
  String get emojiCategoryFlags {
    return Intl.message(
      'Флаги',
      name: 'emojiCategoryFlags',
      desc: '',
      args: [],
    );
  }

  /// `Недавние`
  String get emojiCategoryRecent {
    return Intl.message(
      'Недавние',
      name: 'emojiCategoryRecent',
      desc: '',
      args: [],
    );
  }

  /// `Результаты поиска`
  String get emojiSearchResults {
    return Intl.message(
      'Результаты поиска',
      name: 'emojiSearchResults',
      desc: '',
      args: [],
    );
  }

  /// `В сети`
  String get companionStatusOnline {
    return Intl.message(
      'В сети',
      name: 'companionStatusOnline',
      desc: '',
      args: [],
    );
  }

  /// `Не в сети`
  String get companionStatusOffline {
    return Intl.message(
      'Не в сети',
      name: 'companionStatusOffline',
      desc: '',
      args: [],
    );
  }

  /// `Подходит для совместного общения пользователей. Все участники могут отправлять сообщения и видеть историю переписки.`
  String get conversationTypeGroupHint {
    return Intl.message(
      'Подходит для совместного общения пользователей. Все участники могут отправлять сообщения и видеть историю переписки.',
      name: 'conversationTypeGroupHint',
      desc: '',
      args: [],
    );
  }

  /// `Используется для публикации сообщений. Обычно писать могут только выбранные пользователи, остальные — читать.`
  String get conversationTypeChannelHint {
    return Intl.message(
      'Используется для публикации сообщений. Обычно писать могут только выбранные пользователи, остальные — читать.',
      name: 'conversationTypeChannelHint',
      desc: '',
      args: [],
    );
  }

  /// `Введите имя пользователя или название группы/канала.`
  String get searchUsersAndChatsHint {
    return Intl.message(
      'Введите имя пользователя или название группы/канала.',
      name: 'searchUsersAndChatsHint',
      desc: '',
      args: [],
    );
  }

  /// `Пользователи`
  String get users {
    return Intl.message('Пользователи', name: 'users', desc: '', args: []);
  }

  /// `Чаты`
  String get chats {
    return Intl.message('Чаты', name: 'chats', desc: '', args: []);
  }

  /// `Ничего не найдено`
  String get nothingFound {
    return Intl.message(
      'Ничего не найдено',
      name: 'nothingFound',
      desc: '',
      args: [],
    );
  }

  /// `Попробуйте изменить запрос`
  String get tryAnotherQuery {
    return Intl.message(
      'Попробуйте изменить запрос',
      name: 'tryAnotherQuery',
      desc: '',
      args: [],
    );
  }

  /// `Выберите чат`
  String get selectConversation {
    return Intl.message(
      'Выберите чат',
      name: 'selectConversation',
      desc: '',
      args: [],
    );
  }

  /// `Выберите пользователя, группу или канал, чтобы начать переписку`
  String get selectConversationSubtitle {
    return Intl.message(
      'Выберите пользователя, группу или канал, чтобы начать переписку',
      name: 'selectConversationSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Пока нет переписок`
  String get conversationsListEmptyTitle {
    return Intl.message(
      'Пока нет переписок',
      name: 'conversationsListEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Кнопками выше можно создать новую переписку или найти людей и чаты.`
  String get conversationsListEmptySubtitle {
    return Intl.message(
      'Кнопками выше можно создать новую переписку или найти людей и чаты.',
      name: 'conversationsListEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Требования к паролю`
  String get passwordRequirementsTitle {
    return Intl.message(
      'Требования к паролю',
      name: 'passwordRequirementsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Не менее {min} символов`
  String passwordRequirementMinLength(Object min) {
    return Intl.message(
      'Не менее $min символов',
      name: 'passwordRequirementMinLength',
      desc: '',
      args: [min],
    );
  }

  /// `Хотя бы одна заглавная буква (A–Z)`
  String get passwordRequirementUppercase {
    return Intl.message(
      'Хотя бы одна заглавная буква (A–Z)',
      name: 'passwordRequirementUppercase',
      desc: '',
      args: [],
    );
  }

  /// `Хотя бы одна строчная буква (a–z)`
  String get passwordRequirementLowercase {
    return Intl.message(
      'Хотя бы одна строчная буква (a–z)',
      name: 'passwordRequirementLowercase',
      desc: '',
      args: [],
    );
  }

  /// `Хотя бы одна цифра (0–9)`
  String get passwordRequirementDigit {
    return Intl.message(
      'Хотя бы одна цифра (0–9)',
      name: 'passwordRequirementDigit',
      desc: '',
      args: [],
    );
  }

  /// `Хотя бы один специальный символ (!?@#$%^&*()_-{})`
  String get passwordRequirementSpecial {
    return Intl.message(
      'Хотя бы один специальный символ (!?@#\$%^&*()_-{})',
      name: 'passwordRequirementSpecial',
      desc: '',
      args: [],
    );
  }

  /// `Допустимы только буквы, цифры и спец. символы`
  String get passwordRequirementAllowedChars {
    return Intl.message(
      'Допустимы только буквы, цифры и спец. символы',
      name: 'passwordRequirementAllowedChars',
      desc: '',
      args: [],
    );
  }

  /// `Вы`
  String get you {
    return Intl.message('Вы', name: 'you', desc: '', args: []);
  }

  /// `Загрузка`
  String get loading {
    return Intl.message('Загрузка', name: 'loading', desc: '', args: []);
  }

  /// `Мой профиль`
  String get settingsMyProfile {
    return Intl.message(
      'Мой профиль',
      name: 'settingsMyProfile',
      desc: '',
      args: [],
    );
  }

  /// `Уведомления и звуки`
  String get settingsNotificationsAndSounds {
    return Intl.message(
      'Уведомления и звуки',
      name: 'settingsNotificationsAndSounds',
      desc: '',
      args: [],
    );
  }

  /// `Конфиденциальность`
  String get settingsPrivacy {
    return Intl.message(
      'Конфиденциальность',
      name: 'settingsPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Настройки чатов`
  String get settingsChats {
    return Intl.message(
      'Настройки чатов',
      name: 'settingsChats',
      desc: '',
      args: [],
    );
  }

  /// `Язык`
  String get settingsLanguage {
    return Intl.message('Язык', name: 'settingsLanguage', desc: '', args: []);
  }

  /// `Просмотр и редактирование профиля`
  String get settingsMyProfileDescription {
    return Intl.message(
      'Просмотр и редактирование профиля',
      name: 'settingsMyProfileDescription',
      desc: '',
      args: [],
    );
  }

  /// `Настройка уведомлений и звуков`
  String get settingsNotificationsPlaceholder {
    return Intl.message(
      'Настройка уведомлений и звуков',
      name: 'settingsNotificationsPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Звук`
  String get settingsSound {
    return Intl.message('Звук', name: 'settingsSound', desc: '', args: []);
  }

  /// `Сессия и безопасность`
  String get settingsPrivacyPlaceholder {
    return Intl.message(
      'Сессия и безопасность',
      name: 'settingsPrivacyPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Внешний вид`
  String get settingsChatsAppearance {
    return Intl.message(
      'Внешний вид',
      name: 'settingsChatsAppearance',
      desc: '',
      args: [],
    );
  }

  /// `Сочетания клавиш`
  String get settingsChatsShortcuts {
    return Intl.message(
      'Сочетания клавиш',
      name: 'settingsChatsShortcuts',
      desc: '',
      args: [],
    );
  }

  /// `Сочетания клавиш будут доступны в следующем обновлении.`
  String get settingsChatsShortcutsDescription {
    return Intl.message(
      'Сочетания клавиш будут доступны в следующем обновлении.',
      name: 'settingsChatsShortcutsDescription',
      desc: '',
      args: [],
    );
  }

  /// `О приложении`
  String get aboutApp {
    return Intl.message('О приложении', name: 'aboutApp', desc: '', args: []);
  }

  /// `Загрузка настроек…`
  String get settingsLoading {
    return Intl.message(
      'Загрузка настроек…',
      name: 'settingsLoading',
      desc: '',
      args: [],
    );
  }

  /// `Locnet`
  String get appName {
    return Intl.message('Locnet', name: 'appName', desc: '', args: []);
  }

  /// `Тема`
  String get settingsThemeSection {
    return Intl.message(
      'Тема',
      name: 'settingsThemeSection',
      desc: '',
      args: [],
    );
  }

  /// `Режим`
  String get settingsThemeModeLabel {
    return Intl.message(
      'Режим',
      name: 'settingsThemeModeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Динамическая тема`
  String get settingsDynamicTheme {
    return Intl.message(
      'Динамическая тема',
      name: 'settingsDynamicTheme',
      desc: '',
      args: [],
    );
  }

  /// `Подстроить цвета под обои`
  String get settingsDynamicThemeSubtitle {
    return Intl.message(
      'Подстроить цвета под обои',
      name: 'settingsDynamicThemeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Интерфейс`
  String get settingsInterfaceSection {
    return Intl.message(
      'Интерфейс',
      name: 'settingsInterfaceSection',
      desc: '',
      args: [],
    );
  }

  /// `Размер текста`
  String get settingsTextScale {
    return Intl.message(
      'Размер текста',
      name: 'settingsTextScale',
      desc: '',
      args: [],
    );
  }

  /// `Масштаб элементов`
  String get settingsElementScale {
    return Intl.message(
      'Масштаб элементов',
      name: 'settingsElementScale',
      desc: '',
      args: [],
    );
  }

  /// `Акцент`
  String get settingsAccentSection {
    return Intl.message(
      'Акцент',
      name: 'settingsAccentSection',
      desc: '',
      args: [],
    );
  }

  /// `Предпросмотр`
  String get settingsPreviewLabel {
    return Intl.message(
      'Предпросмотр',
      name: 'settingsPreviewLabel',
      desc: '',
      args: [],
    );
  }

  /// `Push`
  String get settingsPushSection {
    return Intl.message(
      'Push',
      name: 'settingsPushSection',
      desc: '',
      args: [],
    );
  }

  /// `Push-уведомления`
  String get settingsAllowPush {
    return Intl.message(
      'Push-уведомления',
      name: 'settingsAllowPush',
      desc: '',
      args: [],
    );
  }

  /// `Упоминания`
  String get settingsNotifyMentions {
    return Intl.message(
      'Упоминания',
      name: 'settingsNotifyMentions',
      desc: '',
      args: [],
    );
  }

  /// `Системные`
  String get settingsNotifySystem {
    return Intl.message(
      'Системные',
      name: 'settingsNotifySystem',
      desc: '',
      args: [],
    );
  }

  /// `Звуки`
  String get settingsSoundsSection {
    return Intl.message(
      'Звуки',
      name: 'settingsSoundsSection',
      desc: '',
      args: [],
    );
  }

  /// `Входящие сообщения`
  String get settingsSoundNewMessages {
    return Intl.message(
      'Входящие сообщения',
      name: 'settingsSoundNewMessages',
      desc: '',
      args: [],
    );
  }

  /// `Отправка`
  String get settingsSoundSend {
    return Intl.message(
      'Отправка',
      name: 'settingsSoundSend',
      desc: '',
      args: [],
    );
  }

  /// `Системные звуки`
  String get settingsSoundSystem {
    return Intl.message(
      'Системные звуки',
      name: 'settingsSoundSystem',
      desc: '',
      args: [],
    );
  }

  /// `Мелодия`
  String get settingsNotificationSoundTone {
    return Intl.message(
      'Мелодия',
      name: 'settingsNotificationSoundTone',
      desc: '',
      args: [],
    );
  }

  /// `Стандарт`
  String get settingsSoundDefault {
    return Intl.message(
      'Стандарт',
      name: 'settingsSoundDefault',
      desc: '',
      args: [],
    );
  }

  /// `Звонок`
  String get settingsSoundChime {
    return Intl.message(
      'Звонок',
      name: 'settingsSoundChime',
      desc: '',
      args: [],
    );
  }

  /// `Пинг`
  String get settingsSoundPing {
    return Intl.message('Пинг', name: 'settingsSoundPing', desc: '', args: []);
  }

  /// `Поведение`
  String get settingsChatBehaviorSection {
    return Intl.message(
      'Поведение',
      name: 'settingsChatBehaviorSection',
      desc: '',
      args: [],
    );
  }

  /// `Прокрутка к новым`
  String get settingsAutoScroll {
    return Intl.message(
      'Прокрутка к новым',
      name: 'settingsAutoScroll',
      desc: '',
      args: [],
    );
  }

  /// `Отправка по Enter`
  String get settingsSendOnEnter {
    return Intl.message(
      'Отправка по Enter',
      name: 'settingsSendOnEnter',
      desc: '',
      args: [],
    );
  }

  /// `Enter отправляет; Shift+Enter — новая строка ниже`
  String get settingsSendOnEnterSubtitle {
    return Intl.message(
      'Enter отправляет; Shift+Enter — новая строка ниже',
      name: 'settingsSendOnEnterSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Shift+Enter — новая строка`
  String get settingsShiftEnterNewLine {
    return Intl.message(
      'Shift+Enter — новая строка',
      name: 'settingsShiftEnterNewLine',
      desc: '',
      args: [],
    );
  }

  /// `Черновики`
  String get settingsSaveDrafts {
    return Intl.message(
      'Черновики',
      name: 'settingsSaveDrafts',
      desc: '',
      args: [],
    );
  }

  /// `Сменить фото`
  String get profileChangePhoto {
    return Intl.message(
      'Сменить фото',
      name: 'profileChangePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Удалить фото`
  String get profileDeletePhoto {
    return Intl.message(
      'Удалить фото',
      name: 'profileDeletePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Обрезать фото`
  String get profileCropPhoto {
    return Intl.message(
      'Обрезать фото',
      name: 'profileCropPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Сдвиньте или масштабируйте изображение`
  String get profileCropPhotoHint {
    return Intl.message(
      'Сдвиньте или масштабируйте изображение',
      name: 'profileCropPhotoHint',
      desc: '',
      args: [],
    );
  }

  /// `Удалить фото профиля?`
  String get profileDeletePhotoTitle {
    return Intl.message(
      'Удалить фото профиля?',
      name: 'profileDeletePhotoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Фото будет удалено из профиля. Вы сможете загрузить другое в любой момент.`
  String get profileDeletePhotoBody {
    return Intl.message(
      'Фото будет удалено из профиля. Вы сможете загрузить другое в любой момент.',
      name: 'profileDeletePhotoBody',
      desc: '',
      args: [],
    );
  }

  /// `Язык профиля`
  String get profileAccountLanguage {
    return Intl.message(
      'Язык профиля',
      name: 'profileAccountLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Дата регистрации`
  String get profileRegistrationDate {
    return Intl.message(
      'Дата регистрации',
      name: 'profileRegistrationDate',
      desc: '',
      args: [],
    );
  }

  /// `Язык`
  String get companionFieldLanguage {
    return Intl.message(
      'Язык',
      name: 'companionFieldLanguage',
      desc: '',
      args: [],
    );
  }

  /// `О себе`
  String get companionFieldAbout {
    return Intl.message(
      'О себе',
      name: 'companionFieldAbout',
      desc: '',
      args: [],
    );
  }

  /// `Звонок`
  String get companionActionCall {
    return Intl.message(
      'Звонок',
      name: 'companionActionCall',
      desc: '',
      args: [],
    );
  }

  /// `Видео`
  String get companionActionVideo {
    return Intl.message(
      'Видео',
      name: 'companionActionVideo',
      desc: '',
      args: [],
    );
  }

  /// `Написать`
  String get companionActionMessage {
    return Intl.message(
      'Написать',
      name: 'companionActionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Отправьте сообщение, чтобы начать чат`
  String get draftChatHint {
    return Intl.message(
      'Отправьте сообщение, чтобы начать чат',
      name: 'draftChatHint',
      desc: '',
      args: [],
    );
  }

  /// `Переписка пока пустая`
  String get privateDraftConversationEmptyTitle {
    return Intl.message(
      'Переписка пока пустая',
      name: 'privateDraftConversationEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Пока нет сообщений`
  String get conversationNoMessagesYet {
    return Intl.message(
      'Пока нет сообщений',
      name: 'conversationNoMessagesYet',
      desc: '',
      args: [],
    );
  }

  /// `Не беспокоить`
  String get settingsDoNotDisturb {
    return Intl.message(
      'Не беспокоить',
      name: 'settingsDoNotDisturb',
      desc: '',
      args: [],
    );
  }

  /// `Неизвестно`
  String get appVersionUnknown {
    return Intl.message(
      'Неизвестно',
      name: 'appVersionUnknown',
      desc: '',
      args: [],
    );
  }

  /// `Версия {version}`
  String appVersionDisplay(Object version) {
    return Intl.message(
      'Версия $version',
      name: 'appVersionDisplay',
      desc: '',
      args: [version],
    );
  }

  /// `Информация о канале`
  String get channelMenuViewInfo {
    return Intl.message(
      'Информация о канале',
      name: 'channelMenuViewInfo',
      desc: '',
      args: [],
    );
  }

  /// `Покинуть канал`
  String get channelMenuLeave {
    return Intl.message(
      'Покинуть канал',
      name: 'channelMenuLeave',
      desc: '',
      args: [],
    );
  }

  /// `Информация о группе`
  String get groupMenuViewInfo {
    return Intl.message(
      'Информация о группе',
      name: 'groupMenuViewInfo',
      desc: '',
      args: [],
    );
  }

  /// `Покинуть группу`
  String get groupMenuLeave {
    return Intl.message(
      'Покинуть группу',
      name: 'groupMenuLeave',
      desc: '',
      args: [],
    );
  }

  /// `Удалить группу`
  String get groupMenuDelete {
    return Intl.message(
      'Удалить группу',
      name: 'groupMenuDelete',
      desc: '',
      args: [],
    );
  }

  /// `Открыть во внешнем приложении`
  String get mediaOpenExternally {
    return Intl.message(
      'Открыть во внешнем приложении',
      name: 'mediaOpenExternally',
      desc: '',
      args: [],
    );
  }

  /// `{count} подписчиков`
  String channelSubscribersCount(Object count) {
    return Intl.message(
      '$count подписчиков',
      name: 'channelSubscribersCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count} участников`
  String groupParticipantsCount(Object count) {
    return Intl.message(
      '$count участников',
      name: 'groupParticipantsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Не удалось загрузить видео`
  String get mediaVideoLoadFailed {
    return Intl.message(
      'Не удалось загрузить видео',
      name: 'mediaVideoLoadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Срок действия сессии`
  String get settingsPrivacyTimingSection {
    return Intl.message(
      'Срок действия сессии',
      name: 'settingsPrivacyTimingSection',
      desc: '',
      args: [],
    );
  }

  /// `Сборка`
  String get settingsAppVersionTitle {
    return Intl.message(
      'Сборка',
      name: 'settingsAppVersionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Хранилище`
  String get settingsStorageSection {
    return Intl.message(
      'Хранилище',
      name: 'settingsStorageSection',
      desc: '',
      args: [],
    );
  }

  /// `По типу данных`
  String get settingsStorageByType {
    return Intl.message(
      'По типу данных',
      name: 'settingsStorageByType',
      desc: '',
      args: [],
    );
  }

  /// `Действия`
  String get settingsStorageActions {
    return Intl.message(
      'Действия',
      name: 'settingsStorageActions',
      desc: '',
      args: [],
    );
  }

  /// `Очистить кеш`
  String get settingsStorageClearAll {
    return Intl.message(
      'Очистить кеш',
      name: 'settingsStorageClearAll',
      desc: '',
      args: [],
    );
  }

  /// `Очистить кеш`
  String get settingsStorageClearAllTitle {
    return Intl.message(
      'Очистить кеш',
      name: 'settingsStorageClearAllTitle',
      desc: '',
      args: [],
    );
  }

  /// `Все кешированные чаты, сообщения и данные медиа будут удалены. Это действие необратимо.`
  String get settingsStorageClearAllBody {
    return Intl.message(
      'Все кешированные чаты, сообщения и данные медиа будут удалены. Это действие необратимо.',
      name: 'settingsStorageClearAllBody',
      desc: '',
      args: [],
    );
  }

  /// `Кеш пуст`
  String get settingsStorageCacheEmpty {
    return Intl.message(
      'Кеш пуст',
      name: 'settingsStorageCacheEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Данные не кешированы локально.`
  String get settingsStorageCacheEmptyHint {
    return Intl.message(
      'Данные не кешированы локально.',
      name: 'settingsStorageCacheEmptyHint',
      desc: '',
      args: [],
    );
  }

  /// `Очистка кеша не удалит сообщения или медиафайлы с сервера.`
  String get settingsStorageClearCacheHint {
    return Intl.message(
      'Очистка кеша не удалит сообщения или медиафайлы с сервера.',
      name: 'settingsStorageClearCacheHint',
      desc: '',
      args: [],
    );
  }

  /// `Кеш уже пуст.`
  String get settingsStorageAlreadyEmpty {
    return Intl.message(
      'Кеш уже пуст.',
      name: 'settingsStorageAlreadyEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Фотографии`
  String get settingsStoragePhotos {
    return Intl.message(
      'Фотографии',
      name: 'settingsStoragePhotos',
      desc: '',
      args: [],
    );
  }

  /// `Видео`
  String get settingsStorageVideos {
    return Intl.message(
      'Видео',
      name: 'settingsStorageVideos',
      desc: '',
      args: [],
    );
  }

  /// `Аудио`
  String get settingsStorageAudio {
    return Intl.message(
      'Аудио',
      name: 'settingsStorageAudio',
      desc: '',
      args: [],
    );
  }

  /// `Сообщения`
  String get settingsStorageMessages {
    return Intl.message(
      'Сообщения',
      name: 'settingsStorageMessages',
      desc: '',
      args: [],
    );
  }

  /// `Другие файлы`
  String get settingsStorageOtherFiles {
    return Intl.message(
      'Другие файлы',
      name: 'settingsStorageOtherFiles',
      desc: '',
      args: [],
    );
  }

  /// `{size} в кеше`
  String settingsStorageCached(Object size) {
    return Intl.message(
      '$size в кеше',
      name: 'settingsStorageCached',
      desc: '',
      args: [size],
    );
  }

  /// `{size} всего в кеше`
  String settingsStorageTotalCached(Object size) {
    return Intl.message(
      '$size всего в кеше',
      name: 'settingsStorageTotalCached',
      desc: '',
      args: [size],
    );
  }

  /// `Код доступа`
  String get passcodeSectionTitle {
    return Intl.message(
      'Код доступа',
      name: 'passcodeSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Блокировка приложения`
  String get passcodeAppLock {
    return Intl.message(
      'Блокировка приложения',
      name: 'passcodeAppLock',
      desc: '',
      args: [],
    );
  }

  /// `Блокировать через`
  String get passcodeLockAfter {
    return Intl.message(
      'Блокировать через',
      name: 'passcodeLockAfter',
      desc: '',
      args: [],
    );
  }

  /// `Сменить PIN`
  String get passcodeChange {
    return Intl.message(
      'Сменить PIN',
      name: 'passcodeChange',
      desc: '',
      args: [],
    );
  }

  /// `Введите PIN`
  String get passcodeEnterPin {
    return Intl.message(
      'Введите PIN',
      name: 'passcodeEnterPin',
      desc: '',
      args: [],
    );
  }

  /// `Повторите PIN`
  String get passcodeConfirmPin {
    return Intl.message(
      'Повторите PIN',
      name: 'passcodeConfirmPin',
      desc: '',
      args: [],
    );
  }

  /// `Неверный PIN`
  String get passcodeWrongPin {
    return Intl.message(
      'Неверный PIN',
      name: 'passcodeWrongPin',
      desc: '',
      args: [],
    );
  }

  /// `Выйти из аккаунта`
  String get passcodeLogOut {
    return Intl.message(
      'Выйти из аккаунта',
      name: 'passcodeLogOut',
      desc: '',
      args: [],
    );
  }

  /// `Введите PIN, чтобы продолжить`
  String get passcodeUnlockTitle {
    return Intl.message(
      'Введите PIN, чтобы продолжить',
      name: 'passcodeUnlockTitle',
      desc: '',
      args: [],
    );
  }

  /// `Разблокировать`
  String get passcodeUnlockButton {
    return Intl.message(
      'Разблокировать',
      name: 'passcodeUnlockButton',
      desc: '',
      args: [],
    );
  }

  /// `Немедленно`
  String get passcodeImmediate {
    return Intl.message(
      'Немедленно',
      name: 'passcodeImmediate',
      desc: '',
      args: [],
    );
  }

  /// `1 минута`
  String get passcode1Minute {
    return Intl.message(
      '1 минута',
      name: 'passcode1Minute',
      desc: '',
      args: [],
    );
  }

  /// `5 минут`
  String get passcode5Minutes {
    return Intl.message(
      '5 минут',
      name: 'passcode5Minutes',
      desc: '',
      args: [],
    );
  }

  /// `15 минут`
  String get passcode15Minutes {
    return Intl.message(
      '15 минут',
      name: 'passcode15Minutes',
      desc: '',
      args: [],
    );
  }

  /// `30 минут`
  String get passcode30Minutes {
    return Intl.message(
      '30 минут',
      name: 'passcode30Minutes',
      desc: '',
      args: [],
    );
  }

  /// `1 час`
  String get passcode1Hour {
    return Intl.message('1 час', name: 'passcode1Hour', desc: '', args: []);
  }

  /// `Никогда`
  String get passcodeNever {
    return Intl.message('Никогда', name: 'passcodeNever', desc: '', args: []);
  }

  /// `Отключить блокировку`
  String get passcodeDisableTitle {
    return Intl.message(
      'Отключить блокировку',
      name: 'passcodeDisableTitle',
      desc: '',
      args: [],
    );
  }

  /// `PIN не совпадает. Попробуйте снова.`
  String get passcodePinsMismatch {
    return Intl.message(
      'PIN не совпадает. Попробуйте снова.',
      name: 'passcodePinsMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Установка PIN`
  String get passcodeSetupTitle {
    return Intl.message(
      'Установка PIN',
      name: 'passcodeSetupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Смена PIN`
  String get passcodeChangeTitle {
    return Intl.message(
      'Смена PIN',
      name: 'passcodeChangeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Текущий PIN`
  String get passcodeCurrentPin {
    return Intl.message(
      'Текущий PIN',
      name: 'passcodeCurrentPin',
      desc: '',
      args: [],
    );
  }

  /// `{count} мин.`
  String passcodeMinutesCount(Object count) {
    return Intl.message(
      '$count мин.',
      name: 'passcodeMinutesCount',
      desc: '',
      args: [count],
    );
  }

  /// `Поиск сообщений в этой переписке…`
  String get conversationSearchMessagesHint {
    return Intl.message(
      'Поиск сообщений в этой переписке…',
      name: 'conversationSearchMessagesHint',
      desc: '',
      args: [],
    );
  }

  /// `Поиск сообщений в чате`
  String get conversationSearchEmptyTitle {
    return Intl.message(
      'Поиск сообщений в чате',
      name: 'conversationSearchEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Введите запрос, чтобы найти сообщения в этой переписке.`
  String get conversationSearchEmptySubtitle {
    return Intl.message(
      'Введите запрос, чтобы найти сообщения в этой переписке.',
      name: 'conversationSearchEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Ничего не найдено`
  String get conversationSearchNoMatches {
    return Intl.message(
      'Ничего не найдено',
      name: 'conversationSearchNoMatches',
      desc: '',
      args: [],
    );
  }

  /// `{current} из {total}`
  String conversationSearchResultsCount(Object current, Object total) {
    return Intl.message(
      '$current из $total',
      name: 'conversationSearchResultsCount',
      desc: '',
      args: [current, total],
    );
  }

  /// `Сегодня`
  String get conversationSearchDateToday {
    return Intl.message(
      'Сегодня',
      name: 'conversationSearchDateToday',
      desc: '',
      args: [],
    );
  }

  /// `Вчера`
  String get conversationSearchDateYesterday {
    return Intl.message(
      'Вчера',
      name: 'conversationSearchDateYesterday',
      desc: '',
      args: [],
    );
  }

  /// `{count} дн. назад`
  String conversationSearchDateDaysAgo(Object count) {
    return Intl.message(
      '$count дн. назад',
      name: 'conversationSearchDateDaysAgo',
      desc: '',
      args: [count],
    );
  }

  /// `Выбрать`
  String get modalKeyboardHintSelect {
    return Intl.message(
      'Выбрать',
      name: 'modalKeyboardHintSelect',
      desc: '',
      args: [],
    );
  }

  /// `Навигация`
  String get modalKeyboardHintNavigate {
    return Intl.message(
      'Навигация',
      name: 'modalKeyboardHintNavigate',
      desc: '',
      args: [],
    );
  }

  /// `Общие медиа`
  String get conversationSharedMediaTitle {
    return Intl.message(
      'Общие медиа',
      name: 'conversationSharedMediaTitle',
      desc: '',
      args: [],
    );
  }

  /// `с {name}`
  String conversationSharedMediaWithName(Object name) {
    return Intl.message(
      'с $name',
      name: 'conversationSharedMediaWithName',
      desc: '',
      args: [name],
    );
  }

  /// `Фото и медиа`
  String get conversationSharedMediaTabPhotos {
    return Intl.message(
      'Фото и медиа',
      name: 'conversationSharedMediaTabPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Файлы`
  String get conversationSharedMediaTabFiles {
    return Intl.message(
      'Файлы',
      name: 'conversationSharedMediaTabFiles',
      desc: '',
      args: [],
    );
  }

  /// `Ссылки`
  String get conversationSharedMediaTabLinks {
    return Intl.message(
      'Ссылки',
      name: 'conversationSharedMediaTabLinks',
      desc: '',
      args: [],
    );
  }

  /// `Нет общих медиа`
  String get conversationSharedMediaEmptyMedia {
    return Intl.message(
      'Нет общих медиа',
      name: 'conversationSharedMediaEmptyMedia',
      desc: '',
      args: [],
    );
  }

  /// `Нет общих файлов`
  String get conversationSharedMediaEmptyFiles {
    return Intl.message(
      'Нет общих файлов',
      name: 'conversationSharedMediaEmptyFiles',
      desc: '',
      args: [],
    );
  }

  /// `Нет общих ссылок`
  String get conversationSharedMediaEmptyLinks {
    return Intl.message(
      'Нет общих ссылок',
      name: 'conversationSharedMediaEmptyLinks',
      desc: '',
      args: [],
    );
  }

  /// `Вложение`
  String get conversationSharedMediaAttachment {
    return Intl.message(
      'Вложение',
      name: 'conversationSharedMediaAttachment',
      desc: '',
      args: [],
    );
  }

  /// `Общие`
  String get conversationSharedMediaMarkedAsShared {
    return Intl.message(
      'Общие',
      name: 'conversationSharedMediaMarkedAsShared',
      desc: '',
      args: [],
    );
  }

  /// `Поиск людей и сообщений…`
  String get unifiedSearchHint {
    return Intl.message(
      'Поиск людей и сообщений…',
      name: 'unifiedSearchHint',
      desc: '',
      args: [],
    );
  }

  /// `ЛЮДИ`
  String get unifiedSearchPeople {
    return Intl.message(
      'ЛЮДИ',
      name: 'unifiedSearchPeople',
      desc: '',
      args: [],
    );
  }

  /// `СООБЩЕНИЯ`
  String get unifiedSearchMessages {
    return Intl.message(
      'СООБЩЕНИЯ',
      name: 'unifiedSearchMessages',
      desc: '',
      args: [],
    );
  }

  /// `Поиск людей и сообщений`
  String get unifiedSearchInitialTitle {
    return Intl.message(
      'Поиск людей и сообщений',
      name: 'unifiedSearchInitialTitle',
      desc: '',
      args: [],
    );
  }

  /// `Начните ввод, чтобы искать по перепискам`
  String get unifiedSearchInitialSubtitle {
    return Intl.message(
      'Начните ввод, чтобы искать по перепискам',
      name: 'unifiedSearchInitialSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Ничего не найдено`
  String get unifiedSearchNothingFoundTitle {
    return Intl.message(
      'Ничего не найдено',
      name: 'unifiedSearchNothingFoundTitle',
      desc: '',
      args: [],
    );
  }

  /// `Попробуйте изменить поисковый запрос`
  String get unifiedSearchNothingFoundSubtitle {
    return Intl.message(
      'Попробуйте изменить поисковый запрос',
      name: 'unifiedSearchNothingFoundSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Настройки сервера`
  String get serverSettings {
    return Intl.message(
      'Настройки сервера',
      name: 'serverSettings',
      desc: '',
      args: [],
    );
  }

  /// `Base URL`
  String get serverBaseUrl {
    return Intl.message('Base URL', name: 'serverBaseUrl', desc: '', args: []);
  }

  /// `Socket URL`
  String get serverSocketUrl {
    return Intl.message(
      'Socket URL',
      name: 'serverSocketUrl',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить`
  String get serverSettingsSave {
    return Intl.message(
      'Сохранить',
      name: 'serverSettingsSave',
      desc: '',
      args: [],
    );
  }

  /// `Сбросить`
  String get serverSettingsReset {
    return Intl.message(
      'Сбросить',
      name: 'serverSettingsReset',
      desc: '',
      args: [],
    );
  }

  /// `URL должен начинаться с http:// или https://`
  String get serverSettingsInvalidUrl {
    return Intl.message(
      'URL должен начинаться с http:// или https://',
      name: 'serverSettingsInvalidUrl',
      desc: '',
      args: [],
    );
  }

  /// `Нет подключения к интернету`
  String get noInternetConnection {
    return Intl.message(
      'Нет подключения к интернету',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Нет соединения с сервером`
  String get noServerConnection {
    return Intl.message(
      'Нет соединения с сервером',
      name: 'noServerConnection',
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
