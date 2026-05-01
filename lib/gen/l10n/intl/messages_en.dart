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

  static String m0(version) => "Version ${version}";

  static String m1(count) => "${count} subscribers";

  static String m2(count) => "${count} participants";

  static String m3(min) => "At least ${min} characters";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutApp": MessageLookupByLibrary.simpleMessage("About"),
    "accountStatus": MessageLookupByLibrary.simpleMessage("Account status"),
    "alreadyRegisteredQuestion": MessageLookupByLibrary.simpleMessage(
      "Already registered?",
    ),
    "apiForbiddenException": MessageLookupByLibrary.simpleMessage(
      "Access denied, you do not have permission to perform this action",
    ),
    "apiNotFoundException": MessageLookupByLibrary.simpleMessage(
      "Requested resource was not found",
    ),
    "apiServerException": MessageLookupByLibrary.simpleMessage(
      "Server error, please try again later",
    ),
    "apiTimeoutException": MessageLookupByLibrary.simpleMessage(
      "Request timed out, please try again",
    ),
    "apiUnauthorizedException": MessageLookupByLibrary.simpleMessage(
      "Authorization error, please sign in again",
    ),
    "apiValidationException": MessageLookupByLibrary.simpleMessage(
      "Validation error, please check your input",
    ),
    "appException": MessageLookupByLibrary.simpleMessage(
      "An application error occurred",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("Locnet"),
    "appUnknownException": MessageLookupByLibrary.simpleMessage(
      "An unknown error occurred",
    ),
    "appVersionDisplay": m0,
    "appVersionUnknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "authException": MessageLookupByLibrary.simpleMessage(
      "Authentication error",
    ),
    "authInvalidCredentialsException": MessageLookupByLibrary.simpleMessage(
      "Invalid credentials, please check your login or password",
    ),
    "authLoginAlreadyTakenException": MessageLookupByLibrary.simpleMessage(
      "This login is already taken",
    ),
    "authUnauthorizedException": MessageLookupByLibrary.simpleMessage(
      "You are not authorized, please sign in again",
    ),
    "authorization": MessageLookupByLibrary.simpleMessage("Authorization"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "blockCompanion": MessageLookupByLibrary.simpleMessage("Block"),
    "brightnessTitle": MessageLookupByLibrary.simpleMessage("Brightness"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "channelMenuLeave": MessageLookupByLibrary.simpleMessage("Leave channel"),
    "channelMenuViewInfo": MessageLookupByLibrary.simpleMessage(
      "View channel info",
    ),
    "channelSubscribersCount": m1,
    "charactersCountViolationException": MessageLookupByLibrary.simpleMessage(
      "Invalid number of characters",
    ),
    "chats": MessageLookupByLibrary.simpleMessage("Chats"),
    "chooseHowTheAppLooks": MessageLookupByLibrary.simpleMessage(
      "Choose how the app looks",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "colorSchemeBlue": MessageLookupByLibrary.simpleMessage("Blue"),
    "colorSchemeDefault": MessageLookupByLibrary.simpleMessage("Default"),
    "colorSchemeGreen": MessageLookupByLibrary.simpleMessage("Green"),
    "colorSchemePurple": MessageLookupByLibrary.simpleMessage("Purple"),
    "colorSchemeTitle": MessageLookupByLibrary.simpleMessage("Color scheme"),
    "companionActionCall": MessageLookupByLibrary.simpleMessage("Call"),
    "companionActionMessage": MessageLookupByLibrary.simpleMessage("Message"),
    "companionActionVideo": MessageLookupByLibrary.simpleMessage("Video"),
    "companionFieldAbout": MessageLookupByLibrary.simpleMessage("About"),
    "companionFieldLanguage": MessageLookupByLibrary.simpleMessage("Language"),
    "companionStatusOffline": MessageLookupByLibrary.simpleMessage("Offline"),
    "companionStatusOnline": MessageLookupByLibrary.simpleMessage("Online"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "conversationCreating": MessageLookupByLibrary.simpleMessage(
      "Creating conversation",
    ),
    "conversationDescription": MessageLookupByLibrary.simpleMessage(
      "Description",
    ),
    "conversationNoMessagesYet": MessageLookupByLibrary.simpleMessage(
      "No messages yet",
    ),
    "conversationTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "conversationType": MessageLookupByLibrary.simpleMessage("Type"),
    "conversationTypeChannel": MessageLookupByLibrary.simpleMessage("Channel"),
    "conversationTypeChannelHint": MessageLookupByLibrary.simpleMessage(
      "Used for publishing messages. Usually only selected users can write, others can read.",
    ),
    "conversationTypeGroup": MessageLookupByLibrary.simpleMessage("Group"),
    "conversationTypeGroupHint": MessageLookupByLibrary.simpleMessage(
      "Suitable for group conversations. All participants can send messages and see the conversation history.",
    ),
    "conversationTypePrivate": MessageLookupByLibrary.simpleMessage("Private"),
    "conversations": MessageLookupByLibrary.simpleMessage("Conversations"),
    "conversationsListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Use the buttons above to start a new chat or search for people and chats.",
    ),
    "conversationsListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No conversations yet",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create account"),
    "currentSession": MessageLookupByLibrary.simpleMessage("Current session"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteConversation": MessageLookupByLibrary.simpleMessage(
      "Delete conversation",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "deviceThemeMode": MessageLookupByLibrary.simpleMessage(
      "Use device settings",
    ),
    "draftChatHint": MessageLookupByLibrary.simpleMessage(
      "Send a message to start the chat",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "edited": MessageLookupByLibrary.simpleMessage("Edited"),
    "emojiCategoryActivities": MessageLookupByLibrary.simpleMessage(
      "Activities",
    ),
    "emojiCategoryFlags": MessageLookupByLibrary.simpleMessage("Flags"),
    "emojiCategoryFoodAndDrink": MessageLookupByLibrary.simpleMessage(
      "Food and drink",
    ),
    "emojiCategoryNature": MessageLookupByLibrary.simpleMessage(
      "Nature and animals",
    ),
    "emojiCategoryObjects": MessageLookupByLibrary.simpleMessage("Objects"),
    "emojiCategoryRecent": MessageLookupByLibrary.simpleMessage("Recent"),
    "emojiCategorySmileysAndPeople": MessageLookupByLibrary.simpleMessage(
      "Smileys and people",
    ),
    "emojiCategorySymbols": MessageLookupByLibrary.simpleMessage("Symbols"),
    "emojiCategoryTravelAndPlaces": MessageLookupByLibrary.simpleMessage(
      "Travel and places",
    ),
    "emojiSearchResults": MessageLookupByLibrary.simpleMessage(
      "Search results",
    ),
    "filters": MessageLookupByLibrary.simpleMessage("Filters"),
    "firstName": MessageLookupByLibrary.simpleMessage("First name"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "groupMenuDelete": MessageLookupByLibrary.simpleMessage("Delete group"),
    "groupMenuLeave": MessageLookupByLibrary.simpleMessage("Leave group"),
    "groupMenuViewInfo": MessageLookupByLibrary.simpleMessage(
      "View group info",
    ),
    "groupParticipantsCount": m2,
    "homePage": MessageLookupByLibrary.simpleMessage("Home page"),
    "invalidCharactersException": MessageLookupByLibrary.simpleMessage(
      "Invalid characters entered",
    ),
    "jobPosition": MessageLookupByLibrary.simpleMessage("Position"),
    "joinedAt": MessageLookupByLibrary.simpleMessage("Joined at"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "lastName": MessageLookupByLibrary.simpleMessage("Last name"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("Last updated"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading"),
    "logOut": MessageLookupByLibrary.simpleMessage("Log out"),
    "logOutConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to log out?",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "logout": MessageLookupByLibrary.simpleMessage("Log out"),
    "mediaOpenExternally": MessageLookupByLibrary.simpleMessage(
      "Open externally",
    ),
    "mediaVideoLoadFailed": MessageLookupByLibrary.simpleMessage(
      "Could not load video",
    ),
    "message": MessageLookupByLibrary.simpleMessage("Message"),
    "messageContextActionCopyText": MessageLookupByLibrary.simpleMessage(
      "Copy text",
    ),
    "messageContextActionDelete": MessageLookupByLibrary.simpleMessage(
      "Delete",
    ),
    "messageContextActionForward": MessageLookupByLibrary.simpleMessage(
      "Forward",
    ),
    "messageContextActionReply": MessageLookupByLibrary.simpleMessage("Reply"),
    "messageContextActionSelect": MessageLookupByLibrary.simpleMessage(
      "Select",
    ),
    "messageInputToolbarActionCopy": MessageLookupByLibrary.simpleMessage(
      "Copy",
    ),
    "messageInputToolbarActionCut": MessageLookupByLibrary.simpleMessage("Cut"),
    "messageInputToolbarActionDelete": MessageLookupByLibrary.simpleMessage(
      "Delete",
    ),
    "messageInputToolbarActionFormatBold": MessageLookupByLibrary.simpleMessage(
      "Bold",
    ),
    "messageInputToolbarActionFormatCode": MessageLookupByLibrary.simpleMessage(
      "Monospace",
    ),
    "messageInputToolbarActionFormatCodeBlock":
        MessageLookupByLibrary.simpleMessage("Code"),
    "messageInputToolbarActionFormatItalic":
        MessageLookupByLibrary.simpleMessage("Italic"),
    "messageInputToolbarActionFormatLink": MessageLookupByLibrary.simpleMessage(
      "Link",
    ),
    "messageInputToolbarActionFormatStrike":
        MessageLookupByLibrary.simpleMessage("Strikethrough"),
    "messageInputToolbarActionFormatUnderline":
        MessageLookupByLibrary.simpleMessage("Underline"),
    "meta": MessageLookupByLibrary.simpleMessage("Meta"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "noLabel": MessageLookupByLibrary.simpleMessage("No"),
    "notRegisteredYetQuestion": MessageLookupByLibrary.simpleMessage(
      "Not registered yet?",
    ),
    "notSpecified": MessageLookupByLibrary.simpleMessage("Not specified"),
    "nothingFound": MessageLookupByLibrary.simpleMessage("Nothing found"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordRequirementAllowedChars": MessageLookupByLibrary.simpleMessage(
      "Only letters, digits and special characters are allowed",
    ),
    "passwordRequirementDigit": MessageLookupByLibrary.simpleMessage(
      "At least one digit (0–9)",
    ),
    "passwordRequirementLowercase": MessageLookupByLibrary.simpleMessage(
      "At least one lowercase letter (a–z)",
    ),
    "passwordRequirementMinLength": m3,
    "passwordRequirementSpecial": MessageLookupByLibrary.simpleMessage(
      "At least one special character (!?@#\$%^&*()_-{})",
    ),
    "passwordRequirementUppercase": MessageLookupByLibrary.simpleMessage(
      "At least one uppercase letter (A–Z)",
    ),
    "passwordRequirementsTitle": MessageLookupByLibrary.simpleMessage(
      "Password requirements",
    ),
    "passwordTooWeakException": MessageLookupByLibrary.simpleMessage(
      "Password is too weak",
    ),
    "passwordsMismatchException": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "personalInformation": MessageLookupByLibrary.simpleMessage(
      "Personal information",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileChangePhoto": MessageLookupByLibrary.simpleMessage("Change photo"),
    "profileEditing": MessageLookupByLibrary.simpleMessage("Edit profile"),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "repeatPassword": MessageLookupByLibrary.simpleMessage("Repeat password"),
    "requiredValueNotProvidedException": MessageLookupByLibrary.simpleMessage(
      "Required field",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "retry": MessageLookupByLibrary.simpleMessage("Try again"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "searchEmoji": MessageLookupByLibrary.simpleMessage("Search emoji"),
    "searchUsersAndChatsHint": MessageLookupByLibrary.simpleMessage(
      "Enter a username or group/channel name.",
    ),
    "selectConversation": MessageLookupByLibrary.simpleMessage("Select a chat"),
    "selectConversationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Select a user, group or channel to start chatting",
    ),
    "selectInterfaceLanguage": MessageLookupByLibrary.simpleMessage(
      "Select interface language",
    ),
    "sessionAccessExpiresAt": MessageLookupByLibrary.simpleMessage(
      "Access token expires",
    ),
    "sessionCreatedAt": MessageLookupByLibrary.simpleMessage("Created at"),
    "sessionDetails": MessageLookupByLibrary.simpleMessage("Session details"),
    "sessionDeviceName": MessageLookupByLibrary.simpleMessage("Device name"),
    "sessionDeviceType": MessageLookupByLibrary.simpleMessage("Device type"),
    "sessionExpiresAt": MessageLookupByLibrary.simpleMessage("Expires at"),
    "sessionIpAddress": MessageLookupByLibrary.simpleMessage("IP address"),
    "sessionIsExpired": MessageLookupByLibrary.simpleMessage("Expired"),
    "sessionIsNotLoadedYet": MessageLookupByLibrary.simpleMessage(
      "Session data has not been loaded yet. Please try again",
    ),
    "sessionIsTerminated": MessageLookupByLibrary.simpleMessage("Terminated"),
    "sessionMacAddress": MessageLookupByLibrary.simpleMessage("MAC address"),
    "sessionOs": MessageLookupByLibrary.simpleMessage("OS"),
    "sessionRefreshExpiresAt": MessageLookupByLibrary.simpleMessage(
      "Refresh token expires",
    ),
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
    "settingsAccentSection": MessageLookupByLibrary.simpleMessage("Accent"),
    "settingsAllowPush": MessageLookupByLibrary.simpleMessage(
      "Push notifications",
    ),
    "settingsAutoScroll": MessageLookupByLibrary.simpleMessage(
      "Scroll to new messages",
    ),
    "settingsChatBehaviorSection": MessageLookupByLibrary.simpleMessage(
      "Behavior",
    ),
    "settingsChats": MessageLookupByLibrary.simpleMessage("Chats"),
    "settingsChatsAppearance": MessageLookupByLibrary.simpleMessage(
      "Appearance",
    ),
    "settingsChatsShortcuts": MessageLookupByLibrary.simpleMessage(
      "Keyboard shortcuts",
    ),
    "settingsChatsShortcutsDescription": MessageLookupByLibrary.simpleMessage(
      "Shortcuts will be available in a future update.",
    ),
    "settingsDoNotDisturb": MessageLookupByLibrary.simpleMessage(
      "Do not disturb",
    ),
    "settingsDynamicTheme": MessageLookupByLibrary.simpleMessage(
      "Dynamic theme",
    ),
    "settingsDynamicThemeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Match wallpaper tint",
    ),
    "settingsElementScale": MessageLookupByLibrary.simpleMessage("UI density"),
    "settingsInterfaceSection": MessageLookupByLibrary.simpleMessage(
      "Interface",
    ),
    "settingsLanguage": MessageLookupByLibrary.simpleMessage("Language"),
    "settingsLoading": MessageLookupByLibrary.simpleMessage(
      "Loading settings…",
    ),
    "settingsMyProfile": MessageLookupByLibrary.simpleMessage("My profile"),
    "settingsMyProfileDescription": MessageLookupByLibrary.simpleMessage(
      "View and edit your profile",
    ),
    "settingsNotificationSoundTone": MessageLookupByLibrary.simpleMessage(
      "Alert tone",
    ),
    "settingsNotificationsAndSounds": MessageLookupByLibrary.simpleMessage(
      "Notifications and sounds",
    ),
    "settingsNotificationsPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Configure notifications and sounds",
    ),
    "settingsNotifyMentions": MessageLookupByLibrary.simpleMessage("Mentions"),
    "settingsNotifySystem": MessageLookupByLibrary.simpleMessage(
      "System alerts",
    ),
    "settingsPreviewLabel": MessageLookupByLibrary.simpleMessage("Preview"),
    "settingsPrivacy": MessageLookupByLibrary.simpleMessage("Privacy"),
    "settingsPrivacyPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Session and security",
    ),
    "settingsPushSection": MessageLookupByLibrary.simpleMessage("Push"),
    "settingsSaveDrafts": MessageLookupByLibrary.simpleMessage("Save drafts"),
    "settingsSendOnEnter": MessageLookupByLibrary.simpleMessage(
      "Send with Enter",
    ),
    "settingsSendOnEnterSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enter sends; use Shift+Enter for newline below",
    ),
    "settingsShiftEnterNewLine": MessageLookupByLibrary.simpleMessage(
      "Shift+Enter for new line",
    ),
    "settingsSound": MessageLookupByLibrary.simpleMessage("Sound"),
    "settingsSoundChime": MessageLookupByLibrary.simpleMessage("Chime"),
    "settingsSoundDefault": MessageLookupByLibrary.simpleMessage("Default"),
    "settingsSoundNewMessages": MessageLookupByLibrary.simpleMessage(
      "Incoming messages",
    ),
    "settingsSoundPing": MessageLookupByLibrary.simpleMessage("Ping"),
    "settingsSoundSend": MessageLookupByLibrary.simpleMessage("Outgoing send"),
    "settingsSoundSystem": MessageLookupByLibrary.simpleMessage(
      "System sounds",
    ),
    "settingsSoundsSection": MessageLookupByLibrary.simpleMessage("Sounds"),
    "settingsTextScale": MessageLookupByLibrary.simpleMessage("Text size"),
    "settingsThemeModeLabel": MessageLookupByLibrary.simpleMessage("Mode"),
    "settingsThemeSection": MessageLookupByLibrary.simpleMessage("Theme"),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
    "storage": MessageLookupByLibrary.simpleMessage("Storage"),
    "storageException": MessageLookupByLibrary.simpleMessage("Storage error"),
    "storageIOException": MessageLookupByLibrary.simpleMessage(
      "Read/write storage error",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Theme"),
    "themeModeDark": MessageLookupByLibrary.simpleMessage("Dark"),
    "themeModeLight": MessageLookupByLibrary.simpleMessage("Light"),
    "themeModeSystem": MessageLookupByLibrary.simpleMessage("System"),
    "toggleNotificationsOff": MessageLookupByLibrary.simpleMessage(
      "Turn off notifications",
    ),
    "toggleNotificationsOn": MessageLookupByLibrary.simpleMessage(
      "Turn on notifications",
    ),
    "tryAnotherQuery": MessageLookupByLibrary.simpleMessage(
      "Try a different query",
    ),
    "unknownValue": MessageLookupByLibrary.simpleMessage("Unknown"),
    "username": MessageLookupByLibrary.simpleMessage("Username"),
    "users": MessageLookupByLibrary.simpleMessage("Users"),
    "yesLabel": MessageLookupByLibrary.simpleMessage("Yes"),
    "you": MessageLookupByLibrary.simpleMessage("You"),
  };
}
