import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversations/data/data.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/settings/data/data.dart';
import 'package:locnet_app/features/theme_editor/data/data.dart';
import 'package:locnet_app/mock/mock.dart';

abstract interface class IAppEnvPreset {
  IAuthRepo createAuthRepo();
  IUserRepo createUserRepo();
  IUserCacheRepo createUserCacheRepo();
  ISessionCacheRepo createSessionCacheRepo();

  IConversationRepo createConversationRepo();
  IChannelRepo createChannelRepo();
  IPrivateConversationRepo createPrivateConversationRepo();
  IGroupConversationRepo createGroupConversationRepo();
  IConversationsListRepo createConversationsListRepo();

  IMessageRepo createMessageRepo();

  ISettingsRepo createSettingsRepo();
  IThemeEditorRepo createThemeEditorRepo();

  IDeviceInfoRepo createDeviceInfoRepo();
}

sealed class AppEnvPresetsFactory {
  static IAppEnvPreset create({required AppScope appScope}) {
    switch (appScope.env) {
      case AppEnvType.dev:
        final mockBackend = MockInMemoryBackend();
        return DevEnvPreset(appScope: appScope, mockBackend: mockBackend);
      case AppEnvType.stage:
        return StageEnvPreset(appScope: appScope);
      case AppEnvType.prod:
        return ProdEnvPreset(appScope: appScope);
    }
  }
}
