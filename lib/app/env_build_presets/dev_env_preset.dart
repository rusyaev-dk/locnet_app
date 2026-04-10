import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/repositories/repositories.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/settings/data/data.dart';
import 'package:locnet_app/features/settings/domain/domain.dart';
import 'package:locnet_app/features/theme_editor/data/data.dart';
import 'package:locnet_app/mock/mock.dart';

final class DevEnvPreset implements IAppEnvPreset {
  DevEnvPreset({
    required AppScope appScope,
    required MockInMemoryBackend mockBackend,
  }) : _appScope = appScope,
       _mockInMemoryBackend = mockBackend;

  final AppScope _appScope;
  final MockInMemoryBackend _mockInMemoryBackend;
  static const bool _useHttpPrivateMessaging = false;

  @override
  IAuthRepo createAuthRepo() {
    return MockAuthRepo();
    // return HttpAuthRepo(
    //   httpClient: DioHttpClient(
    //     dio: _appScope.dio,
    //     apiConfig: _appScope.apiConfig,
    //   ),
    // );
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
    return MockConversationsListRepo(backendStorage: _mockInMemoryBackend);
  }

  @override
  IChannelRepo createChannelRepo() {
    return MockChannelRepo(backendStorage: _mockInMemoryBackend);
  }

  @override
  IGroupRepo createGroupConversationRepo() {
    return MockGroupRepo(backendStorage: _mockInMemoryBackend);
  }

  @override
  IPrivateMessageRepo createPrivateMessageRepo() {
    if (_useHttpPrivateMessaging) {
      return HttpPrivateMessageRepo(
        httpClient: DioHttpClient(
          dio: _appScope.dio,
          apiConfig: _appScope.apiConfig,
        ),
      );
    }

    return MockPrivateMessageRepo(backendStorage: _mockInMemoryBackend);
  }

  @override
  IGroupMessageRepo createGroupMessageRepo() {
    return MockGroupMessageRepo(backendStorage: _mockInMemoryBackend);
  }

  @override
  IChannelPublicationRepo createChannelPublicationRepo() {
    return MockChannelPublicationRepo(backendStorage: _mockInMemoryBackend);
  }

  @override
  IPrivateConversationRepo createPrivateConversationRepo() {
    if (_useHttpPrivateMessaging) {
      return HttpPrivateConversationRepo(
        httpClient: DioHttpClient(
          dio: _appScope.dio,
          apiConfig: _appScope.apiConfig,
        ),
        sessionCacheRepo: LocalSessionCacheRepo(
          storage: _appScope.storageAggregator.secureStorage,
        ),
        logger: _appScope.logger,
        socketBaseUrl: _appScope.apiConfig.baseUrl,
      );
    }

    return MockPrivateConversationRepo(backendStorage: _mockInMemoryBackend);
  }

  @override
  IUserRepo createUserRepo() {
    return MockUserRepo(backendStorage: _mockInMemoryBackend);
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
    return MockUnifiedSearchRepo(backend: _mockInMemoryBackend);
  }
}
