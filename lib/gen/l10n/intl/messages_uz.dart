// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a uz locale. All the
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
  String get localeName => 'uz';

  static String m0(version) => "Versiya ${version}";

  static String m1(count) => "${count} obunachi";

  static String m2(count) => "${count} kun oldin";

  static String m3(current, total) => "${current} / ${total}";

  static String m4(name) => "${name} bilan";

  static String m5(count) =>
      "Tanlangan ${count} ta xabarni oʻchirishni xohlaysizmi?";

  static String m6(count) => "${count} ishtirokchi";

  static String m7(count) => "${count} daq.";

  static String m8(min) => "Kamida ${min} ta belgi";

  static String m9(size) => "${size} keshda";

  static String m10(size) => "${size} jami keshda";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutApp": MessageLookupByLibrary.simpleMessage("Ilova haqida"),
    "accountStatus": MessageLookupByLibrary.simpleMessage("Profil holati"),
    "alreadyRegisteredQuestion": MessageLookupByLibrary.simpleMessage(
      "Allaqachon roʻyxatdan oʻtgansizmi?",
    ),
    "apiForbiddenException": MessageLookupByLibrary.simpleMessage(
      "Ruxsat etilmagan, sizda ushbu amalni bajarish huquqi yoʻq",
    ),
    "apiNotFoundException": MessageLookupByLibrary.simpleMessage(
      "Soʻralgan resurs topilmadi",
    ),
    "apiServerException": MessageLookupByLibrary.simpleMessage(
      "Server xatosi, keyinroq qayta urinib koʻring",
    ),
    "apiTimeoutException": MessageLookupByLibrary.simpleMessage(
      "Soʻrov vaqti tugadi, iltimos, qayta urinib koʻring",
    ),
    "apiUnauthorizedException": MessageLookupByLibrary.simpleMessage(
      "Avtorizatsiya xatosi, iltimos, qayta kiring",
    ),
    "apiValidationException": MessageLookupByLibrary.simpleMessage(
      "Tekshiruv xatosi, kiritilgan maʼlumotlarni tekshiring",
    ),
    "appException": MessageLookupByLibrary.simpleMessage(
      "Ilovada xatolik yuz berdi",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("Locnet"),
    "appUnknownException": MessageLookupByLibrary.simpleMessage(
      "Nomaʼlum xatolik yuz berdi",
    ),
    "appVersionDisplay": m0,
    "appVersionUnknown": MessageLookupByLibrary.simpleMessage("Noma\'lum"),
    "appearance": MessageLookupByLibrary.simpleMessage("Koʻrinishi"),
    "apply": MessageLookupByLibrary.simpleMessage("Qoʻllash"),
    "authException": MessageLookupByLibrary.simpleMessage(
      "Autentifikatsiya xatosi",
    ),
    "authInvalidCredentialsException": MessageLookupByLibrary.simpleMessage(
      "Login yoki parol notoʻgʻri, maʼlumotlarni tekshiring",
    ),
    "authLoginAlreadyTakenException": MessageLookupByLibrary.simpleMessage(
      "Bu login allaqachon band",
    ),
    "authUnauthorizedException": MessageLookupByLibrary.simpleMessage(
      "Siz tizimga kirmagansiz, iltimos, qayta kiring",
    ),
    "authorization": MessageLookupByLibrary.simpleMessage("Avtorizatsiya"),
    "back": MessageLookupByLibrary.simpleMessage("Orqaga"),
    "blockCompanion": MessageLookupByLibrary.simpleMessage("Bloklash"),
    "brightnessTitle": MessageLookupByLibrary.simpleMessage(
      "Yorugʻ / qorongʻi mavzu",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Bekor qilish"),
    "channelMenuLeave": MessageLookupByLibrary.simpleMessage(
      "Kanaldan chiqish",
    ),
    "channelMenuViewInfo": MessageLookupByLibrary.simpleMessage("Kanal haqida"),
    "channelSubscribersCount": m1,
    "charactersCountViolationException": MessageLookupByLibrary.simpleMessage(
      "Belgilar soni notoʻgʻri",
    ),
    "chats": MessageLookupByLibrary.simpleMessage("Chatlar"),
    "chooseHowTheAppLooks": MessageLookupByLibrary.simpleMessage(
      "Ilova koʻrinishini tanlang",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Tozalash"),
    "close": MessageLookupByLibrary.simpleMessage("Yopish"),
    "colorSchemeBlue": MessageLookupByLibrary.simpleMessage("Koʻk"),
    "colorSchemeDefault": MessageLookupByLibrary.simpleMessage("Standart"),
    "colorSchemeGreen": MessageLookupByLibrary.simpleMessage("Yashil"),
    "colorSchemePurple": MessageLookupByLibrary.simpleMessage("Binafsha"),
    "colorSchemeTitle": MessageLookupByLibrary.simpleMessage("Rang sxemasi"),
    "companionActionCall": MessageLookupByLibrary.simpleMessage("Qo‘ng‘iroq"),
    "companionActionMessage": MessageLookupByLibrary.simpleMessage("Xabar"),
    "companionActionVideo": MessageLookupByLibrary.simpleMessage("Video"),
    "companionFieldAbout": MessageLookupByLibrary.simpleMessage("Haqida"),
    "companionFieldLanguage": MessageLookupByLibrary.simpleMessage("Til"),
    "companionStatusOffline": MessageLookupByLibrary.simpleMessage("Oflayn"),
    "companionStatusOnline": MessageLookupByLibrary.simpleMessage("Onlayn"),
    "confirm": MessageLookupByLibrary.simpleMessage("Tasdiqlash"),
    "conversationCreating": MessageLookupByLibrary.simpleMessage(
      "Suhbat yaratish",
    ),
    "conversationDescription": MessageLookupByLibrary.simpleMessage("Tavsif"),
    "conversationNoMessagesYet": MessageLookupByLibrary.simpleMessage(
      "Hali xabar yo‘q",
    ),
    "conversationSearchDateDaysAgo": m2,
    "conversationSearchDateToday": MessageLookupByLibrary.simpleMessage(
      "Bugun",
    ),
    "conversationSearchDateYesterday": MessageLookupByLibrary.simpleMessage(
      "Kecha",
    ),
    "conversationSearchEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Ushbu suhbatdagi xabarlarni topish uchun so‘rov kiriting.",
    ),
    "conversationSearchEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Chatda xabarlarni qidirish",
    ),
    "conversationSearchMessagesHint": MessageLookupByLibrary.simpleMessage(
      "Ushbu suhbatda xabarlarni qidirish…",
    ),
    "conversationSearchNoMatches": MessageLookupByLibrary.simpleMessage(
      "Hech narsa topilmadi",
    ),
    "conversationSearchResultsCount": m3,
    "conversationSharedMediaAttachment": MessageLookupByLibrary.simpleMessage(
      "Birikma",
    ),
    "conversationSharedMediaEmptyFiles": MessageLookupByLibrary.simpleMessage(
      "Umumiy fayllar yo‘q",
    ),
    "conversationSharedMediaEmptyLinks": MessageLookupByLibrary.simpleMessage(
      "Umumiy havolalar yo‘q",
    ),
    "conversationSharedMediaEmptyMedia": MessageLookupByLibrary.simpleMessage(
      "Umumiy media yo‘q",
    ),
    "conversationSharedMediaMarkedAsShared":
        MessageLookupByLibrary.simpleMessage("Umumiy"),
    "conversationSharedMediaTabFiles": MessageLookupByLibrary.simpleMessage(
      "Fayllar",
    ),
    "conversationSharedMediaTabLinks": MessageLookupByLibrary.simpleMessage(
      "Havolalar",
    ),
    "conversationSharedMediaTabPhotos": MessageLookupByLibrary.simpleMessage(
      "Foto va media",
    ),
    "conversationSharedMediaTitle": MessageLookupByLibrary.simpleMessage(
      "Umumiy media",
    ),
    "conversationSharedMediaWithName": m4,
    "conversationTitle": MessageLookupByLibrary.simpleMessage("Sarlavha"),
    "conversationType": MessageLookupByLibrary.simpleMessage("Turi"),
    "conversationTypeChannel": MessageLookupByLibrary.simpleMessage("Kanal"),
    "conversationTypeChannelHint": MessageLookupByLibrary.simpleMessage(
      "Xabarlarni eʼlon qilish uchun ishlatiladi. Odatda faqat tanlangan foydalanuvchilar yozishi, boshqalar oʻqishi mumkin.",
    ),
    "conversationTypeGroup": MessageLookupByLibrary.simpleMessage("Guruh"),
    "conversationTypeGroupHint": MessageLookupByLibrary.simpleMessage(
      "Guruh suhbatlari uchun mos. Barcha ishtirokchilar xabar yuborishi va tarixni koʻrishi mumkin.",
    ),
    "conversationTypePrivate": MessageLookupByLibrary.simpleMessage("Shaxsiy"),
    "conversations": MessageLookupByLibrary.simpleMessage("Suhbatlar"),
    "conversationsListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Yuqoridagi tugmalar bilan yangi suhbat boshlash yoki odamlar va chatlarni qidirish mumkin.",
    ),
    "conversationsListEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Hozircha suhbatlar yoʻq",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Yaratish"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Hisob yaratish"),
    "currentSession": MessageLookupByLibrary.simpleMessage("Joriy sessiya"),
    "delete": MessageLookupByLibrary.simpleMessage("Oʻchirish"),
    "deleteConversation": MessageLookupByLibrary.simpleMessage(
      "Suhbatni oʻchirish",
    ),
    "deleteMessageConfirmation": MessageLookupByLibrary.simpleMessage(
      "Bu xabarni oʻchirishni xohlaysizmi?",
    ),
    "deletePrivateConversationBody": MessageLookupByLibrary.simpleMessage(
      "Chat roʻyxatdan olib tashlanadi. Davom etasizmi?",
    ),
    "deleteSelectedMessagesConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("Tavsif"),
    "deviceThemeMode": MessageLookupByLibrary.simpleMessage(
      "Qurilma sozlamalariga koʻra",
    ),
    "draftChatHint": MessageLookupByLibrary.simpleMessage(
      "Suhbatni boshlash uchun xabar yuboring",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Tahrirlash"),
    "edited": MessageLookupByLibrary.simpleMessage("Tahrirlangan"),
    "emojiCategoryActivities": MessageLookupByLibrary.simpleMessage(
      "Faoliyatlar",
    ),
    "emojiCategoryFlags": MessageLookupByLibrary.simpleMessage("Bayroqlar"),
    "emojiCategoryFoodAndDrink": MessageLookupByLibrary.simpleMessage(
      "Oziq-ovqat va ichimliklar",
    ),
    "emojiCategoryNature": MessageLookupByLibrary.simpleMessage(
      "Tabiat va hayvonlar",
    ),
    "emojiCategoryObjects": MessageLookupByLibrary.simpleMessage("Obyektlar"),
    "emojiCategoryRecent": MessageLookupByLibrary.simpleMessage(
      "Yaqinda ishlatilgan",
    ),
    "emojiCategorySmileysAndPeople": MessageLookupByLibrary.simpleMessage(
      "Smayllar va odamlar",
    ),
    "emojiCategorySymbols": MessageLookupByLibrary.simpleMessage("Belgilar"),
    "emojiCategoryTravelAndPlaces": MessageLookupByLibrary.simpleMessage(
      "Sayohat va joylar",
    ),
    "emojiSearchResults": MessageLookupByLibrary.simpleMessage(
      "Qidiruv natijalari",
    ),
    "filters": MessageLookupByLibrary.simpleMessage("Filtrlar"),
    "firstName": MessageLookupByLibrary.simpleMessage("Ism"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage(
      "Parolni unutdingizmi?",
    ),
    "groupMenuDelete": MessageLookupByLibrary.simpleMessage(
      "Guruhni oʻchirish",
    ),
    "groupMenuLeave": MessageLookupByLibrary.simpleMessage("Guruhdan chiqish"),
    "groupMenuViewInfo": MessageLookupByLibrary.simpleMessage("Guruh haqida"),
    "groupParticipantsCount": m6,
    "homePage": MessageLookupByLibrary.simpleMessage("Bosh sahifa"),
    "invalidCharactersException": MessageLookupByLibrary.simpleMessage(
      "Notoʻgʻri belgilar kiritildi",
    ),
    "jobPosition": MessageLookupByLibrary.simpleMessage("Lavozim"),
    "joinedAt": MessageLookupByLibrary.simpleMessage("Qoʻshilgan sana"),
    "language": MessageLookupByLibrary.simpleMessage("Til"),
    "lastName": MessageLookupByLibrary.simpleMessage("Familiya"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("Oxirgi yangilanish"),
    "loading": MessageLookupByLibrary.simpleMessage("Yuklanmoqda"),
    "logOut": MessageLookupByLibrary.simpleMessage("Chiqish"),
    "logOutConfirmation": MessageLookupByLibrary.simpleMessage(
      "Haqiqatan ham tizimdan chiqmoqchimisiz?",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "logout": MessageLookupByLibrary.simpleMessage("Chiqish"),
    "mediaOpenExternally": MessageLookupByLibrary.simpleMessage(
      "Tashqi ilovada ochish",
    ),
    "mediaVideoLoadFailed": MessageLookupByLibrary.simpleMessage(
      "Videoni yuklab boʻlmadi",
    ),
    "message": MessageLookupByLibrary.simpleMessage("Xabar"),
    "messageContextActionCopyText": MessageLookupByLibrary.simpleMessage(
      "Matnni nusxalash",
    ),
    "messageContextActionDelete": MessageLookupByLibrary.simpleMessage(
      "Oʻchirish",
    ),
    "messageContextActionForward": MessageLookupByLibrary.simpleMessage(
      "Yuborish",
    ),
    "messageContextActionReply": MessageLookupByLibrary.simpleMessage(
      "Javob berish",
    ),
    "messageContextActionSelect": MessageLookupByLibrary.simpleMessage(
      "Tanlash",
    ),
    "messageInputToolbarActionCopy": MessageLookupByLibrary.simpleMessage(
      "Nusxalash",
    ),
    "messageInputToolbarActionCut": MessageLookupByLibrary.simpleMessage(
      "Kesish",
    ),
    "messageInputToolbarActionDelete": MessageLookupByLibrary.simpleMessage(
      "Oʻchirish",
    ),
    "messageInputToolbarActionFormatBold": MessageLookupByLibrary.simpleMessage(
      "Qalin",
    ),
    "messageInputToolbarActionFormatCode": MessageLookupByLibrary.simpleMessage(
      "Monospace",
    ),
    "messageInputToolbarActionFormatCodeBlock":
        MessageLookupByLibrary.simpleMessage("Kod"),
    "messageInputToolbarActionFormatItalic":
        MessageLookupByLibrary.simpleMessage("Kursiv"),
    "messageInputToolbarActionFormatLink": MessageLookupByLibrary.simpleMessage(
      "Havola",
    ),
    "messageInputToolbarActionFormatStrike":
        MessageLookupByLibrary.simpleMessage("Ustidan chizilgan"),
    "messageInputToolbarActionFormatUnderline":
        MessageLookupByLibrary.simpleMessage("Tagi chizilgan"),
    "meta": MessageLookupByLibrary.simpleMessage("Meta"),
    "modalKeyboardHintNavigate": MessageLookupByLibrary.simpleMessage(
      "Navigatsiya",
    ),
    "modalKeyboardHintSelect": MessageLookupByLibrary.simpleMessage("Tanlash"),
    "next": MessageLookupByLibrary.simpleMessage("Keyingi"),
    "noLabel": MessageLookupByLibrary.simpleMessage("Yoʻq"),
    "notRegisteredYetQuestion": MessageLookupByLibrary.simpleMessage(
      "Roʻyxatdan oʻtmagansizmi?",
    ),
    "notSpecified": MessageLookupByLibrary.simpleMessage("Koʻrsatilmagan"),
    "nothingFound": MessageLookupByLibrary.simpleMessage(
      "Hech narsa topilmadi",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "passcode15Minutes": MessageLookupByLibrary.simpleMessage("15 daqiqa"),
    "passcode1Hour": MessageLookupByLibrary.simpleMessage("1 soat"),
    "passcode1Minute": MessageLookupByLibrary.simpleMessage("1 daqiqa"),
    "passcode30Minutes": MessageLookupByLibrary.simpleMessage("30 daqiqa"),
    "passcode5Minutes": MessageLookupByLibrary.simpleMessage("5 daqiqa"),
    "passcodeAppLock": MessageLookupByLibrary.simpleMessage("Ilova bloklash"),
    "passcodeChange": MessageLookupByLibrary.simpleMessage(
      "PINni almashtirish",
    ),
    "passcodeChangeTitle": MessageLookupByLibrary.simpleMessage(
      "PINni almashtirish",
    ),
    "passcodeConfirmPin": MessageLookupByLibrary.simpleMessage(
      "PINni tasdiqlang",
    ),
    "passcodeCurrentPin": MessageLookupByLibrary.simpleMessage("Joriy PIN"),
    "passcodeDisableTitle": MessageLookupByLibrary.simpleMessage(
      "Bloklashni o\'chirish",
    ),
    "passcodeEnterPin": MessageLookupByLibrary.simpleMessage("PIN kiriting"),
    "passcodeImmediate": MessageLookupByLibrary.simpleMessage("Darhol"),
    "passcodeLockAfter": MessageLookupByLibrary.simpleMessage(
      "Nofaollikdan keyin bloklash",
    ),
    "passcodeLogOut": MessageLookupByLibrary.simpleMessage("Hisobdan chiqish"),
    "passcodeMinutesCount": m7,
    "passcodeNever": MessageLookupByLibrary.simpleMessage("Hech qachon"),
    "passcodePinsMismatch": MessageLookupByLibrary.simpleMessage(
      "PIN mos kelmaydi. Qayta urinib ko\'ring.",
    ),
    "passcodeSectionTitle": MessageLookupByLibrary.simpleMessage("Kod"),
    "passcodeSetupTitle": MessageLookupByLibrary.simpleMessage(
      "PIN o\'rnatish",
    ),
    "passcodeUnlockButton": MessageLookupByLibrary.simpleMessage(
      "Blokdan chiqish",
    ),
    "passcodeUnlockTitle": MessageLookupByLibrary.simpleMessage(
      "Davom etish uchun PIN kiriting",
    ),
    "passcodeWrongPin": MessageLookupByLibrary.simpleMessage("Noto\'g\'ri PIN"),
    "password": MessageLookupByLibrary.simpleMessage("Parol"),
    "passwordRequirementAllowedChars": MessageLookupByLibrary.simpleMessage(
      "Faqat harflar, raqamlar va maxsus belgilar ruxsat etiladi",
    ),
    "passwordRequirementDigit": MessageLookupByLibrary.simpleMessage(
      "Kamida bitta raqam (0–9)",
    ),
    "passwordRequirementLowercase": MessageLookupByLibrary.simpleMessage(
      "Kamida bitta kichik harf (a–z)",
    ),
    "passwordRequirementMinLength": m8,
    "passwordRequirementSpecial": MessageLookupByLibrary.simpleMessage(
      "Kamida bitta maxsus belgi (!?@#\$%^&*()_-{})",
    ),
    "passwordRequirementUppercase": MessageLookupByLibrary.simpleMessage(
      "Kamida bitta katta harf (A–Z)",
    ),
    "passwordRequirementsTitle": MessageLookupByLibrary.simpleMessage(
      "Parol talablari",
    ),
    "passwordTooWeakException": MessageLookupByLibrary.simpleMessage(
      "Parol juda zaif",
    ),
    "passwordsMismatchException": MessageLookupByLibrary.simpleMessage(
      "Parollar mos kelmaydi",
    ),
    "personalInformation": MessageLookupByLibrary.simpleMessage(
      "Shaxsiy maʼlumotlar",
    ),
    "privateDraftConversationEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Bu suhbat hali bo‘sh",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Profil"),
    "profileChangePhoto": MessageLookupByLibrary.simpleMessage(
      "Fotoni almashtirish",
    ),
    "profileCropPhoto": MessageLookupByLibrary.simpleMessage("Fotoni qirqish"),
    "profileCropPhotoHint": MessageLookupByLibrary.simpleMessage(
      "Siljiting yoki kichraytiring/kattalashtiring",
    ),
    "profileDeletePhoto": MessageLookupByLibrary.simpleMessage(
      "Fotoni oʻchirish",
    ),
    "profileDeletePhotoBody": MessageLookupByLibrary.simpleMessage(
      "Profil fotosi olib tashlanadi. Istalgan vaqtda yangi fotoni yuklashingiz mumkin.",
    ),
    "profileDeletePhotoTitle": MessageLookupByLibrary.simpleMessage(
      "Profil fotosi olib tashlansinmi?",
    ),
    "profileEditing": MessageLookupByLibrary.simpleMessage(
      "Profilni tahrirlash",
    ),
    "registration": MessageLookupByLibrary.simpleMessage("Roʻyxatdan oʻtish"),
    "repeatPassword": MessageLookupByLibrary.simpleMessage(
      "Parolni takrorlang",
    ),
    "requiredValueNotProvidedException": MessageLookupByLibrary.simpleMessage(
      "Majburiy maydon",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Tiklash"),
    "retry": MessageLookupByLibrary.simpleMessage("Qayta urinib koʻrish"),
    "save": MessageLookupByLibrary.simpleMessage("Saqlash"),
    "search": MessageLookupByLibrary.simpleMessage("Qidirish"),
    "searchEmoji": MessageLookupByLibrary.simpleMessage("Emoji qidirish"),
    "searchUsersAndChatsHint": MessageLookupByLibrary.simpleMessage(
      "Foydalanuvchi nomi yoki guruh/kanal nomini kiriting.",
    ),
    "selectConversation": MessageLookupByLibrary.simpleMessage(
      "Chatni tanlang",
    ),
    "selectConversationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Suhbatni boshlash uchun foydalanuvchi, guruh yoki kanalni tanlang",
    ),
    "selectInterfaceLanguage": MessageLookupByLibrary.simpleMessage(
      "Interfeys tilini tanlang",
    ),
    "sessionAccessExpiresAt": MessageLookupByLibrary.simpleMessage(
      "Access token muddati",
    ),
    "sessionCreatedAt": MessageLookupByLibrary.simpleMessage("Yaratilgan vaqt"),
    "sessionDetails": MessageLookupByLibrary.simpleMessage(
      "Sessiya tafsilotlari",
    ),
    "sessionDeviceName": MessageLookupByLibrary.simpleMessage("Qurilma nomi"),
    "sessionDeviceType": MessageLookupByLibrary.simpleMessage("Qurilma turi"),
    "sessionExpiresAt": MessageLookupByLibrary.simpleMessage("Tugash vaqti"),
    "sessionIpAddress": MessageLookupByLibrary.simpleMessage("IP manzil"),
    "sessionIsExpired": MessageLookupByLibrary.simpleMessage("Muddati tugagan"),
    "sessionIsNotLoadedYet": MessageLookupByLibrary.simpleMessage(
      "Sessiya maʼlumotlari hali yuklanmadi. Iltimos, qayta urinib koʻring",
    ),
    "sessionIsTerminated": MessageLookupByLibrary.simpleMessage("Yakunlangan"),
    "sessionMacAddress": MessageLookupByLibrary.simpleMessage("MAC manzil"),
    "sessionOs": MessageLookupByLibrary.simpleMessage("OT"),
    "sessionRefreshExpiresAt": MessageLookupByLibrary.simpleMessage(
      "Refresh token muddati",
    ),
    "sessionSessionId": MessageLookupByLibrary.simpleMessage("Sessiya ID"),
    "sessionStatusActive": MessageLookupByLibrary.simpleMessage("Faol"),
    "sessionStatusExpired": MessageLookupByLibrary.simpleMessage(
      "Muddati tugagan",
    ),
    "sessionStatusTerminated": MessageLookupByLibrary.simpleMessage(
      "Yakunlangan",
    ),
    "sessionTerminatedAt": MessageLookupByLibrary.simpleMessage(
      "Yakunlangan vaqt",
    ),
    "sessionUpdatedAt": MessageLookupByLibrary.simpleMessage(
      "Yangilangan vaqt",
    ),
    "sessionUserId": MessageLookupByLibrary.simpleMessage("Foydalanuvchi ID"),
    "settings": MessageLookupByLibrary.simpleMessage("Sozlamalar"),
    "settingsAccentSection": MessageLookupByLibrary.simpleMessage("Aksent"),
    "settingsAllowPush": MessageLookupByLibrary.simpleMessage(
      "Push-bildirishnomalar",
    ),
    "settingsAppVersionTitle": MessageLookupByLibrary.simpleMessage("Yigʻma"),
    "settingsAutoScroll": MessageLookupByLibrary.simpleMessage(
      "Yangilariga aylantirish",
    ),
    "settingsChatBehaviorSection": MessageLookupByLibrary.simpleMessage(
      "Xulq-atvor",
    ),
    "settingsChats": MessageLookupByLibrary.simpleMessage("Chat sozlamalari"),
    "settingsChatsAppearance": MessageLookupByLibrary.simpleMessage(
      "Koʻrinishi",
    ),
    "settingsChatsShortcuts": MessageLookupByLibrary.simpleMessage(
      "Tugmalar birikmasi",
    ),
    "settingsChatsShortcutsDescription": MessageLookupByLibrary.simpleMessage(
      "Tugmalar birikmasi keyingi yangilanishda qoʻshiladi.",
    ),
    "settingsDoNotDisturb": MessageLookupByLibrary.simpleMessage(
      "Bezovta qilmang",
    ),
    "settingsDynamicTheme": MessageLookupByLibrary.simpleMessage(
      "Dinamik mavzu",
    ),
    "settingsDynamicThemeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Fonda ranglarga moslash",
    ),
    "settingsElementScale": MessageLookupByLibrary.simpleMessage(
      "Elementlar miqyosi",
    ),
    "settingsInterfaceSection": MessageLookupByLibrary.simpleMessage(
      "Interfeys",
    ),
    "settingsLanguage": MessageLookupByLibrary.simpleMessage("Til"),
    "settingsLoading": MessageLookupByLibrary.simpleMessage(
      "Sozlamalar yuklanmoqda…",
    ),
    "settingsMyProfile": MessageLookupByLibrary.simpleMessage(
      "Mening profilim",
    ),
    "settingsMyProfileDescription": MessageLookupByLibrary.simpleMessage(
      "Profilni koʻrish va tahrirlash",
    ),
    "settingsNotificationSoundTone": MessageLookupByLibrary.simpleMessage(
      "Signal melodiyasi",
    ),
    "settingsNotificationsAndSounds": MessageLookupByLibrary.simpleMessage(
      "Bildirishnomalar va tovushlar",
    ),
    "settingsNotificationsPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Bildirishnomalar va tovushlarni sozlash",
    ),
    "settingsNotifyMentions": MessageLookupByLibrary.simpleMessage(
      "Eslatmalar",
    ),
    "settingsNotifySystem": MessageLookupByLibrary.simpleMessage("Tizim"),
    "settingsPreviewLabel": MessageLookupByLibrary.simpleMessage(
      "Oldindan ko‘rish",
    ),
    "settingsPrivacy": MessageLookupByLibrary.simpleMessage("Maxfiylik"),
    "settingsPrivacyPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Sessiya va xavfsizlik",
    ),
    "settingsPrivacyTimingSection": MessageLookupByLibrary.simpleMessage(
      "Sessiya muddati",
    ),
    "settingsPushSection": MessageLookupByLibrary.simpleMessage("Push"),
    "settingsSaveDrafts": MessageLookupByLibrary.simpleMessage(
      "Qoralamalarni saqlash",
    ),
    "settingsSendOnEnter": MessageLookupByLibrary.simpleMessage(
      "Enter bilan yuborish",
    ),
    "settingsSendOnEnterSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enter yuboradi; Shift+Enter — yangi qator pastda",
    ),
    "settingsShiftEnterNewLine": MessageLookupByLibrary.simpleMessage(
      "Shift+Enter — yangi qator",
    ),
    "settingsSound": MessageLookupByLibrary.simpleMessage("Tovush"),
    "settingsSoundChime": MessageLookupByLibrary.simpleMessage("Zang"),
    "settingsSoundDefault": MessageLookupByLibrary.simpleMessage("Standart"),
    "settingsSoundNewMessages": MessageLookupByLibrary.simpleMessage(
      "Kiruvchi xabarlar",
    ),
    "settingsSoundPing": MessageLookupByLibrary.simpleMessage("Ping"),
    "settingsSoundSend": MessageLookupByLibrary.simpleMessage("Yuborish"),
    "settingsSoundSystem": MessageLookupByLibrary.simpleMessage(
      "Tizim tovushlari",
    ),
    "settingsSoundsSection": MessageLookupByLibrary.simpleMessage("Tovushlar"),
    "settingsStorageActions": MessageLookupByLibrary.simpleMessage("Amallar"),
    "settingsStorageAlreadyEmpty": MessageLookupByLibrary.simpleMessage(
      "Kesh allaqachon bo\'sh.",
    ),
    "settingsStorageAudio": MessageLookupByLibrary.simpleMessage("Audio"),
    "settingsStorageByType": MessageLookupByLibrary.simpleMessage(
      "Tur bo\'yicha",
    ),
    "settingsStorageCacheEmpty": MessageLookupByLibrary.simpleMessage(
      "Kesh bo\'sh",
    ),
    "settingsStorageCacheEmptyHint": MessageLookupByLibrary.simpleMessage(
      "Mahalliy keşlangan ma\'lumot yo\'q.",
    ),
    "settingsStorageCached": m9,
    "settingsStorageClearAll": MessageLookupByLibrary.simpleMessage(
      "Keshni tozalash",
    ),
    "settingsStorageClearAllBody": MessageLookupByLibrary.simpleMessage(
      "Barcha keşlangan suhbatlar, xabarlar va media ma\'lumotlari o\'chiriladi. Bu amalni qaytarib bo\'lmaydi.",
    ),
    "settingsStorageClearAllTitle": MessageLookupByLibrary.simpleMessage(
      "Keshni tozalash",
    ),
    "settingsStorageClearCacheHint": MessageLookupByLibrary.simpleMessage(
      "Keshni tozalash xabarlar yoki medialarni serverdan o\'chirmaydi.",
    ),
    "settingsStorageMessages": MessageLookupByLibrary.simpleMessage("Xabarlar"),
    "settingsStorageOtherFiles": MessageLookupByLibrary.simpleMessage(
      "Boshqa fayllar",
    ),
    "settingsStoragePhotos": MessageLookupByLibrary.simpleMessage("Rasmlar"),
    "settingsStorageSection": MessageLookupByLibrary.simpleMessage(
      "Saqlash joyi",
    ),
    "settingsStorageTotalCached": m10,
    "settingsStorageVideos": MessageLookupByLibrary.simpleMessage("Videolar"),
    "settingsTextScale": MessageLookupByLibrary.simpleMessage("Matn o‘lchami"),
    "settingsThemeModeLabel": MessageLookupByLibrary.simpleMessage("Rejim"),
    "settingsThemeSection": MessageLookupByLibrary.simpleMessage("Mavzu"),
    "share": MessageLookupByLibrary.simpleMessage("Ulashish"),
    "signIn": MessageLookupByLibrary.simpleMessage("Kirish"),
    "storage": MessageLookupByLibrary.simpleMessage("Xotira"),
    "storageException": MessageLookupByLibrary.simpleMessage("Xotira xatosi"),
    "storageIOException": MessageLookupByLibrary.simpleMessage(
      "Xotiraga oʻqish/yozish xatosi",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Mavzu"),
    "themeModeDark": MessageLookupByLibrary.simpleMessage("Qorongʻi"),
    "themeModeLight": MessageLookupByLibrary.simpleMessage("Yorugʻ"),
    "themeModeSystem": MessageLookupByLibrary.simpleMessage("Tizimniki"),
    "toggleNotificationsOff": MessageLookupByLibrary.simpleMessage(
      "Bildirishnomalarni oʻchirish",
    ),
    "toggleNotificationsOn": MessageLookupByLibrary.simpleMessage(
      "Bildirishnomalarni yoqish",
    ),
    "tryAnotherQuery": MessageLookupByLibrary.simpleMessage(
      "Boshqa soʻrovni sinab koʻring",
    ),
    "unifiedSearchHint": MessageLookupByLibrary.simpleMessage(
      "Odamlar va xabarlarni qidirish…",
    ),
    "unifiedSearchInitialSubtitle": MessageLookupByLibrary.simpleMessage(
      "Suhbatlar bo\'yicha qidirish uchun yozishni boshlang",
    ),
    "unifiedSearchInitialTitle": MessageLookupByLibrary.simpleMessage(
      "Odamlar va xabarlarni qidirish",
    ),
    "unifiedSearchMessages": MessageLookupByLibrary.simpleMessage("XABARLAR"),
    "unifiedSearchNothingFoundSubtitle": MessageLookupByLibrary.simpleMessage(
      "Boshqa qidiruv so\'zini sinab ko\'ring",
    ),
    "unifiedSearchNothingFoundTitle": MessageLookupByLibrary.simpleMessage(
      "Hech narsa topilmadi",
    ),
    "unifiedSearchPeople": MessageLookupByLibrary.simpleMessage("ODAMLAR"),
    "unknownValue": MessageLookupByLibrary.simpleMessage("Nomaʼlum"),
    "username": MessageLookupByLibrary.simpleMessage("Foydalanuvchi nomi"),
    "users": MessageLookupByLibrary.simpleMessage("Foydalanuvchilar"),
    "yesLabel": MessageLookupByLibrary.simpleMessage("Ha"),
    "you": MessageLookupByLibrary.simpleMessage("Siz"),
  };
}
