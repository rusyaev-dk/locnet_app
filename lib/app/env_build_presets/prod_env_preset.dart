import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/conversation/data/repositories/conversation_repo/i_conversation_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/repositories/channel_repo/i_channel_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/repositories/group_conversation_repo/i_group_conversation_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/repositories/private_conversation_repo/i_private_conversation_repo.dart';
import 'package:locnet_app/features/conversations/data/repositories/conversations_list_repo/i_conversations_list_repo.dart';
import 'package:locnet_app/features/message/data/repositories/message_repo/i_message_repo.dart';
import 'package:locnet_app/features/settings/data/data.dart';
import 'package:locnet_app/features/theme_editor/data/data.dart';

final class ProdEnvPreset implements IAppEnvPreset {
  ProdEnvPreset({required AppScope appScope})
    : _appScope = appScope,
      _httpClient = DioHttpClient(
        dio: appScope.dio,
        apiConfig: appScope.apiConfig,
      );

  final AppScope _appScope;
  final IHttpClient _httpClient;

  @override
  IAuthRepo createAuthRepo() {
    _httpClient.hashCode;
    throw UnimplementedError();
    // return HttpAuthRepo(httpClient: _httpClient);
  }

  @override
  ISettingsRepo createSettingsRepo() {
    return LocalSettingsRepo(
      storage: _appScope.storageAggregator.localKeyValueStorage,
    );
  }

  @override
  IThemeEditorRepo createThemeEditorRepo() {
    return LocalThemeEditorRepo(
      storage: _appScope.storageAggregator.localKeyValueStorage,
    );
  }

  @override
  IConversationsListRepo createConversationsListRepo() {
    // TODO: implement conversationsListRepo
    throw UnimplementedError();
  }

  @override
  IChannelRepo createChannelRepo() {
    // TODO: implement createChannelRepo
    throw UnimplementedError();
  }

  @override
  IConversationRepo createConversationRepo() {
    // TODO: implement createConversationRepo
    throw UnimplementedError();
  }

  @override
  IGroupConversationRepo createGroupConversationRepo() {
    // TODO: implement createGroupConversationRepo
    throw UnimplementedError();
  }

  @override
  IMessageRepo createMessageRepo() {
    // TODO: implement createMessageRepo
    throw UnimplementedError();
  }

  @override
  IPrivateConversationRepo createPrivateConversationRepo() {
    // TODO: implement createPrivateConversationRepo
    throw UnimplementedError();
  }

  @override
  IUserRepo createUserRepo() {
    // TODO: implement createUserRepo
    throw UnimplementedError();
  }

  @override
  ISessionCacheRepo createSessionCacheRepo() {
    return LocalSessionCacheRepo(
      storage: _appScope.storageAggregator.secureStorage,
    );
  }

  @override
  IUserCacheRepo createUserCacheRepo() {
    return LocalUserCacheRepo(
      storage: _appScope.storageAggregator.secureStorage,
    );
  }

  @override
  IDeviceInfoRepo createDeviceInfoRepo() {
    return const DeviceInfoRepo();
  }
}
