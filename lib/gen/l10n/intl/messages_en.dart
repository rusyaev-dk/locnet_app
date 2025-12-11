// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accountStatus": MessageLookupByLibrary.simpleMessage("Account status"),
    "alreadyRegisteredQuestion": MessageLookupByLibrary.simpleMessage(
      "Already registered?",
    ),
    "apiConnectionException": MessageLookupByLibrary.simpleMessage(
      "Connection error, please check your internet connection",
    ),
    "apiForbiddenException": MessageLookupByLibrary.simpleMessage(
      "Access denied, you do not have permission to perform this action",
    ),
    "apiNotFoundException": MessageLookupByLibrary.simpleMessage(
      "Requested resource not found",
    ),
    "apiServerException": MessageLookupByLibrary.simpleMessage(
      "Server error, please try again later",
    ),
    "apiTimeoutException": MessageLookupByLibrary.simpleMessage(
      "Request timeout exceeded, please try again",
    ),
    "apiUnauthorizedException": MessageLookupByLibrary.simpleMessage(
      "Authorization error, please sign in again",
    ),
    "apiUnknownException": MessageLookupByLibrary.simpleMessage(
      "Unknown error occurred while requesting the server",
    ),
    "apiValidationException": MessageLookupByLibrary.simpleMessage(
      "Data validation error, please check the entered information",
    ),
    "appException": MessageLookupByLibrary.simpleMessage(
      "Application error occurred",
    ),
    "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "authExpiredSessionException": MessageLookupByLibrary.simpleMessage(
      "Session expired, please sign in again",
    ),
    "authInvalidCredentialsException": MessageLookupByLibrary.simpleMessage(
      "Invalid credentials, please check your login or password",
    ),
    "authUnauthorizedException": MessageLookupByLibrary.simpleMessage(
      "You are not authorized, please sign in again",
    ),
    "authUnknownException": MessageLookupByLibrary.simpleMessage(
      "Unknown error occurred during authorization",
    ),
    "authorization": MessageLookupByLibrary.simpleMessage("Authorization"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "blockCompanion": MessageLookupByLibrary.simpleMessage("Заблокировать"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "chooseHowTheAppLooks": MessageLookupByLibrary.simpleMessage(
      "Choose how the app looks",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "conversationCreateException": MessageLookupByLibrary.simpleMessage(
      "Failed to create conversation",
    ),
    "conversationCreating": MessageLookupByLibrary.simpleMessage(
      "Создание переписки",
    ),
    "conversationDataTooLongException": MessageLookupByLibrary.simpleMessage(
      "Provided data is too long",
    ),
    "conversationDescription": MessageLookupByLibrary.simpleMessage("Описание"),
    "conversationEmptyFieldException": MessageLookupByLibrary.simpleMessage(
      "This field cannot be empty",
    ),
    "conversationTitle": MessageLookupByLibrary.simpleMessage("Название"),
    "conversationType": MessageLookupByLibrary.simpleMessage("Тип"),
    "conversationTypeChannel": MessageLookupByLibrary.simpleMessage("Канал"),
    "conversationTypeGroup": MessageLookupByLibrary.simpleMessage("Группа"),
    "conversationTypePrivate": MessageLookupByLibrary.simpleMessage("Личная"),
    "conversations": MessageLookupByLibrary.simpleMessage("Conversations"),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "currentSession": MessageLookupByLibrary.simpleMessage("Current session"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteConversation": MessageLookupByLibrary.simpleMessage(
      "Удалить переписку",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "deviceThemeMode": MessageLookupByLibrary.simpleMessage(
      "Same as on device",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "edited": MessageLookupByLibrary.simpleMessage("Изменено"),
    "filteringClearException": MessageLookupByLibrary.simpleMessage(
      "Failed to reset filters",
    ),
    "filteringSaveException": MessageLookupByLibrary.simpleMessage(
      "Failed to save filters",
    ),
    "filteringUpdateException": MessageLookupByLibrary.simpleMessage(
      "Failed to update filters",
    ),
    "filters": MessageLookupByLibrary.simpleMessage("Фильтры"),
    "homePage": MessageLookupByLibrary.simpleMessage("Home page"),
    "jobPosition": MessageLookupByLibrary.simpleMessage("Job position"),
    "jobPositionInvalidCharactersException":
        MessageLookupByLibrary.simpleMessage(
          "Job position contains invalid characters",
        ),
    "joinedAt": MessageLookupByLibrary.simpleMessage("Joined at"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("Last updated"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "message": MessageLookupByLibrary.simpleMessage("Сообщение"),
    "meta": MessageLookupByLibrary.simpleMessage("Meta"),
    "nameInvalidCharactersException": MessageLookupByLibrary.simpleMessage(
      "Name contains invalid characters",
    ),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "noLabel": MessageLookupByLibrary.simpleMessage("No"),
    "notSpecified": MessageLookupByLibrary.simpleMessage("Not specified"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordInvalidCharactersException": MessageLookupByLibrary.simpleMessage(
      "Password contains invalid characters",
    ),
    "passwordNoDigitException": MessageLookupByLibrary.simpleMessage(
      "Password must contain a digit",
    ),
    "passwordNoLowerCaseException": MessageLookupByLibrary.simpleMessage(
      "Password must contain a lowercase letter",
    ),
    "passwordNoUpperCaseException": MessageLookupByLibrary.simpleMessage(
      "Password must contain an uppercase letter",
    ),
    "passwordTooShortException": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 14 characters long",
    ),
    "passwordsMatchException": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "personalInformation": MessageLookupByLibrary.simpleMessage(
      "Personal information",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileEditing": MessageLookupByLibrary.simpleMessage("Edit profile"),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationEmptyFieldException": MessageLookupByLibrary.simpleMessage(
      "Поле обязательно для заполнения",
    ),
    "registrationPasswordsDontMatchException":
        MessageLookupByLibrary.simpleMessage("Passwords do not match"),
    "registrationQuestion": MessageLookupByLibrary.simpleMessage(
      "Not registered yet?",
    ),
    "repeatPassword": MessageLookupByLibrary.simpleMessage("Repeat password"),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "retry": MessageLookupByLibrary.simpleMessage("Try again"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "search": MessageLookupByLibrary.simpleMessage("Поиск"),
    "searchUnknownException": MessageLookupByLibrary.simpleMessage(
      "Unknown error occurred during search",
    ),
    "selectInterfaceLanguage": MessageLookupByLibrary.simpleMessage(
      "Select interface language",
    ),
    "sessionCreatedAt": MessageLookupByLibrary.simpleMessage("Created at"),
    "sessionDetails": MessageLookupByLibrary.simpleMessage("Session details"),
    "sessionDeviceName": MessageLookupByLibrary.simpleMessage("Device name"),
    "sessionDeviceType": MessageLookupByLibrary.simpleMessage("Device type"),
    "sessionExpiresAt": MessageLookupByLibrary.simpleMessage("Expires at"),
    "sessionIpAddress": MessageLookupByLibrary.simpleMessage("IP address"),
    "sessionIsExpired": MessageLookupByLibrary.simpleMessage("Is expired"),
    "sessionIsTerminated": MessageLookupByLibrary.simpleMessage(
      "Is terminated",
    ),
    "sessionMacAddress": MessageLookupByLibrary.simpleMessage("MAC address"),
    "sessionOs": MessageLookupByLibrary.simpleMessage("OS"),
    "sessionSessionId": MessageLookupByLibrary.simpleMessage("Session ID"),
    "sessionStatusActive": MessageLookupByLibrary.simpleMessage("Active"),
    "sessionStatusExpired": MessageLookupByLibrary.simpleMessage("Expired"),
    "sessionStatusTerminated": MessageLookupByLibrary.simpleMessage(
      "Terminated",
    ),
    "sessionTerminatedAt": MessageLookupByLibrary.simpleMessage(
      "Terminated at",
    ),
    "sessionUpdatedAt": MessageLookupByLibrary.simpleMessage("Updated at"),
    "sessionUserId": MessageLookupByLibrary.simpleMessage("User ID"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsLocaleChangeException": MessageLookupByLibrary.simpleMessage(
      "Failed to change language",
    ),
    "settingsRestoreLocaleException": MessageLookupByLibrary.simpleMessage(
      "Failed to load language",
    ),
    "settingsRestoreThemeModeException": MessageLookupByLibrary.simpleMessage(
      "Failed to load theme",
    ),
    "settingsThemeModeChangeException": MessageLookupByLibrary.simpleMessage(
      "Failed to change theme",
    ),
    "settingsUnknownException": MessageLookupByLibrary.simpleMessage(
      "Unknown error occurred while accessing settings",
    ),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
    "sortingClearException": MessageLookupByLibrary.simpleMessage(
      "Failed to reset sorting",
    ),
    "sortingSaveException": MessageLookupByLibrary.simpleMessage(
      "Failed to save sorting",
    ),
    "sortingUpdateException": MessageLookupByLibrary.simpleMessage(
      "Failed to update sorting",
    ),
    "storage": MessageLookupByLibrary.simpleMessage("Storage"),
    "storageDeleteException": MessageLookupByLibrary.simpleMessage(
      "Error deleting data from storage",
    ),
    "storageNotFoundException": MessageLookupByLibrary.simpleMessage(
      "Data not found in storage",
    ),
    "storageReadException": MessageLookupByLibrary.simpleMessage(
      "Error reading data from storage",
    ),
    "storageSerializationException": MessageLookupByLibrary.simpleMessage(
      "Data serialization error",
    ),
    "storageUnknownException": MessageLookupByLibrary.simpleMessage(
      "Unknown error occurred while accessing storage",
    ),
    "storageWriteException": MessageLookupByLibrary.simpleMessage(
      "Error saving data to storage",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Theme"),
    "themeModeDark": MessageLookupByLibrary.simpleMessage("Dark"),
    "themeModeLight": MessageLookupByLibrary.simpleMessage("Light"),
    "themeModeSystem": MessageLookupByLibrary.simpleMessage("System"),
    "toggleNotificationsOff": MessageLookupByLibrary.simpleMessage(
      "Выключить уведомления",
    ),
    "toggleNotificationsOn": MessageLookupByLibrary.simpleMessage(
      "Включить уведомления",
    ),
    "unknownValue": MessageLookupByLibrary.simpleMessage("Unknown"),
    "userFavouritesAddException": MessageLookupByLibrary.simpleMessage(
      "Failed to add to favorites",
    ),
    "userFavouritesDeleteException": MessageLookupByLibrary.simpleMessage(
      "Failed to remove from favorites",
    ),
    "userFavouritesLoadException": MessageLookupByLibrary.simpleMessage(
      "Failed to load favorites",
    ),
    "userFavouritesUnknownException": MessageLookupByLibrary.simpleMessage(
      "Unknown error occurred while accessing favorites",
    ),
    "username": MessageLookupByLibrary.simpleMessage("Username"),
    "usernameInvalidCharactersException": MessageLookupByLibrary.simpleMessage(
      "Username contains invalid characters",
    ),
    "yesLabel": MessageLookupByLibrary.simpleMessage("Yes"),
  };
}
