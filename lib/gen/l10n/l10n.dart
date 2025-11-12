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

  /// `Произошла ошибка приложения`
  String get appException {
    return Intl.message(
      'Произошла ошибка приложения',
      name: 'appException',
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

  /// `Ошибка соединения, проверьте интернет-подключение`
  String get apiConnectionException {
    return Intl.message(
      'Ошибка соединения, проверьте интернет-подключение',
      name: 'apiConnectionException',
      desc: '',
      args: [],
    );
  }

  /// `Неизвестная ошибка при запросе к серверу`
  String get apiUnknownException {
    return Intl.message(
      'Неизвестная ошибка при запросе к серверу',
      name: 'apiUnknownException',
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

  /// `Ошибка чтения данных из хранилища`
  String get storageReadException {
    return Intl.message(
      'Ошибка чтения данных из хранилища',
      name: 'storageReadException',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка сериализации данных`
  String get storageSerializationException {
    return Intl.message(
      'Ошибка сериализации данных',
      name: 'storageSerializationException',
      desc: '',
      args: [],
    );
  }

  /// `Неизвестная ошибка при работе с хранилищем`
  String get storageUnknownException {
    return Intl.message(
      'Неизвестная ошибка при работе с хранилищем',
      name: 'storageUnknownException',
      desc: '',
      args: [],
    );
  }

  /// `Данные не найдены в хранилище`
  String get storageNotFoundException {
    return Intl.message(
      'Данные не найдены в хранилище',
      name: 'storageNotFoundException',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка сохранения данных в хранилище`
  String get storageWriteException {
    return Intl.message(
      'Ошибка сохранения данных в хранилище',
      name: 'storageWriteException',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка удаления данных из хранилища`
  String get storageDeleteException {
    return Intl.message(
      'Ошибка удаления данных из хранилища',
      name: 'storageDeleteException',
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

  /// `Сессия истекла, пожалуйста, выполните вход снова`
  String get authExpiredSessionException {
    return Intl.message(
      'Сессия истекла, пожалуйста, выполните вход снова',
      name: 'authExpiredSessionException',
      desc: '',
      args: [],
    );
  }

  /// `Неизвестная ошибка при авторизации`
  String get authUnknownException {
    return Intl.message(
      'Неизвестная ошибка при авторизации',
      name: 'authUnknownException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось сохранить сортировку`
  String get sortingSaveException {
    return Intl.message(
      'Не удалось сохранить сортировку',
      name: 'sortingSaveException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось сбросить сортировку`
  String get sortingClearException {
    return Intl.message(
      'Не удалось сбросить сортировку',
      name: 'sortingClearException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось обновить сортировку`
  String get sortingUpdateException {
    return Intl.message(
      'Не удалось обновить сортировку',
      name: 'sortingUpdateException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось сохранить фильтры`
  String get filteringSaveException {
    return Intl.message(
      'Не удалось сохранить фильтры',
      name: 'filteringSaveException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось сбросить фильтры`
  String get filteringClearException {
    return Intl.message(
      'Не удалось сбросить фильтры',
      name: 'filteringClearException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось обновить фильтры`
  String get filteringUpdateException {
    return Intl.message(
      'Не удалось обновить фильтры',
      name: 'filteringUpdateException',
      desc: '',
      args: [],
    );
  }

  /// `Неизвестная ошибка при поиске`
  String get searchUnknownException {
    return Intl.message(
      'Неизвестная ошибка при поиске',
      name: 'searchUnknownException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось сменить язык`
  String get settingsLocaleChangeException {
    return Intl.message(
      'Не удалось сменить язык',
      name: 'settingsLocaleChangeException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось сменить тему`
  String get settingsThemeModeChangeException {
    return Intl.message(
      'Не удалось сменить тему',
      name: 'settingsThemeModeChangeException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось загрузить язык`
  String get settingsRestoreLocaleException {
    return Intl.message(
      'Не удалось загрузить язык',
      name: 'settingsRestoreLocaleException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось загрузить тему`
  String get settingsRestoreThemeModeException {
    return Intl.message(
      'Не удалось загрузить тему',
      name: 'settingsRestoreThemeModeException',
      desc: '',
      args: [],
    );
  }

  /// `Неизвестная ошибка при работе с настройками`
  String get settingsUnknownException {
    return Intl.message(
      'Неизвестная ошибка при работе с настройками',
      name: 'settingsUnknownException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось добавить в избранное`
  String get userFavouritesAddException {
    return Intl.message(
      'Не удалось добавить в избранное',
      name: 'userFavouritesAddException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось удалить из избранного`
  String get userFavouritesDeleteException {
    return Intl.message(
      'Не удалось удалить из избранного',
      name: 'userFavouritesDeleteException',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось загрузить избранное`
  String get userFavouritesLoadException {
    return Intl.message(
      'Не удалось загрузить избранное',
      name: 'userFavouritesLoadException',
      desc: '',
      args: [],
    );
  }

  /// `Неизвестная ошибка при работе с избранным`
  String get userFavouritesUnknownException {
    return Intl.message(
      'Неизвестная ошибка при работе с избранным',
      name: 'userFavouritesUnknownException',
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
