import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';

final class TelegramAuthDataSourceRepo implements IAuthDataSourceRepo {
  TelegramAuthDataSourceRepo();

  @override
  Future<TelegramAuthPayload> getAuthPayload() async {
    // Ensure web environment and Telegram namespace presence
    if (!kIsWeb || telegram?.webApp == null) {
      throw StateError('Telegram WebApp is not available in this environment');
    }

    final WebApp webApp = telegram!.webApp!
      ..ready()
      ..expand();

    final String initData = webApp.initData;
    if (initData.isEmpty) {
      throw StateError('Telegram initData is empty');
    }

    final TgUser? tgUser = webApp.initDataUnsafe?.user;
    final String userId = tgUser?.id.toString() ?? '';

    // Optional: pack minimal TG user snapshot as JSON string
    final String data = tgUser == null
        ? '{}'
        : jsonEncode(<String, Object?>{
            'id': tgUser.id,
            'username': tgUser.username,
            'first_name': tgUser.first_name,
            'last_name': tgUser.last_name,
            'language_code': tgUser.language_code,
            'is_premium': tgUser.is_premium,
          });

    return TelegramAuthPayload(
      initData: initData,
      userId: userId,
      username: tgUser?.username,
      data: data,
    );
  }
}
