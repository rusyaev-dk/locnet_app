import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/repositories/channel_repo/i_channel_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/repositories/group_repo/i_group_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/repositories/private_conversation_repo/i_private_conversation_repo.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';
import 'package:locnet_app/features/conversations_list/data/repositories/conversations_list_repo/i_conversations_list_repo.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/data.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/settings/data/data.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/theme_editor/data/data.dart';
import 'package:locnet_app/mock/mock.dart';

final class StageEnvPreset implements IAppEnvPreset {
  StageEnvPreset({required AppScope appScope})
    : _appScope = appScope,
      _httpClient = DioHttpClient(
        dio: appScope.dio,
        apiConfig: appScope.apiConfig,
      );

  final AppScope _appScope;
  final IHttpClient _httpClient;

  @override
  IAuthRepo createAuthRepo() {
    return HttpAuthRepo(httpClient: _httpClient);
  }

  @override
  ISettingsRepo createSettingsRepo() {
    return LocalSettingsRepo(
      storage: _appScope.storageAggregator.localKeyValueStorage,
    );
  }

  @override
  IThemeRepository createThemeRepo() {
    return LocalThemeRepository(
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
    return HttpConversationsListRepo(httpClient: _httpClient);
  }

  @override
  IChannelRepo createChannelRepo() {
    // TODO: implement createChannelRepo
    throw UnimplementedError();
  }

  @override
  IGroupRepo createGroupConversationRepo() {
    // TODO: implement createGroupConversationRepo
    throw UnimplementedError();
  }

  @override
  IPrivateMessageRepo createPrivateMessageRepo() {
    return MockPrivateMessageRepo(backendStorage: MockInMemoryBackend());
  }

  @override
  IGroupMessageRepo createGroupMessageRepo() {
    return MockGroupMessageRepo(backendStorage: MockInMemoryBackend());
  }

  @override
  IChannelPublicationRepo createChannelPublicationRepo() {
    return MockChannelPublicationRepo(backendStorage: MockInMemoryBackend());
  }

  @override
  IPrivateConversationRepo createPrivateConversationRepo() {
    // TODO: implement createPrivateConversationRepo
    throw UnimplementedError();
  }

  @override
  IUserRepo createUserRepo() {
    return HttpUserRepo(httpClient: _httpClient);
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

  @override
  IUnifiedSearchRepo createUnifiedSearchRepo() {
    return HttpUnifiedSearchRepo(httpClient: _httpClient);
  }
}
