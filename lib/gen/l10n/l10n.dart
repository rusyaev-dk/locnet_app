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
