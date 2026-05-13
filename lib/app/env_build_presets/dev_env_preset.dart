import 'package:flutter/foundation.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/repositories/private_conversation_repo/drift_cached_private_conversation_repo.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';
import 'package:locnet_app/features/conversations_list/data/repositories/conversations_list_repo/drift_cached_conversations_list_repo.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/repositories/repositories.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/repositories/media_download_cache_repo/drift_media_download_cache_repo.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/repositories/media_download_cache_repo/i_media_download_cache_repo.dart';
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

  AppDatabase get _db => _appScope.db;
  bool get _useMacOsFallbackStorage =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  IKeyValueStorage get _sessionStorage => _useMacOsFallbackStorage
      ? _appScope.storageAggregator.localKeyValueStorage
      : _appScope.storageAggregator.secureStorage;

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
    return DriftCachedConversationsListRepo(
      network: MockConversationsListRepo(backendStorage: _mockInMemoryBackend),
      tilesDao: _db.conversationTilesDao,
    );
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
  IMediaRepo createMediaRepo() {
    return HttpMediaRepo(
      httpClient: DioHttpClient(
        dio: _appScope.dio,
        apiConfig: _appScope.apiConfig,
      ),
    );
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
    final IPrivateConversationRepo networkRepo = _useHttpPrivateMessaging
        ? HttpPrivateConversationRepo(
            httpClient: DioHttpClient(
              dio: _appScope.dio,
              apiConfig: _appScope.apiConfig,
            ),
            apiConfig: _appScope.apiConfig,
            sessionCacheRepo: LocalSessionCacheRepo(storage: _sessionStorage),
            logger: _appScope.logger,
          )
        : MockPrivateConversationRepo(backendStorage: _mockInMemoryBackend);

    return DriftCachedPrivateConversationRepo(
      network: networkRepo,
      messagesDao: _db.privateMessagesDao,
    );
  }

  @override
  IMediaDownloadCacheRepo createMediaDownloadCacheRepo() =>
      DriftMediaDownloadCacheRepo(dao: _db.mediaDownloadCacheDao);

  @override
  IUserRepo createUserRepo() {
    return MockUserRepo(backendStorage: _mockInMemoryBackend);
  }

  @override
  ISessionCacheRepo createSessionCacheRepo() {
    return LocalSessionCacheRepo(storage: _sessionStorage);
  }

  @override
  IUserCacheRepo createUserCacheRepo() {
    return LocalUserCacheRepo(storage: _sessionStorage);
  }

  @override
  IDeviceInfoRepo createDeviceInfoRepo() {
    return createPlatformDeviceInfoRepo();
  }

  @override
  IUnifiedSearchRepo createUnifiedSearchRepo() {
    return MockUnifiedSearchRepo(backend: _mockInMemoryBackend);
  }
}
