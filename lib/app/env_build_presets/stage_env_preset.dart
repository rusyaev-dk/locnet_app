import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/repositories/channel_repo/i_channel_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/repositories/group_repo/i_group_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/repositories/private_conversation_repo/drift_cached_private_conversation_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/repositories/private_conversation_repo/http_private_conversation_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/repositories/private_conversation_repo/i_private_conversation_repo.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';
import 'package:locnet_app/features/conversations_list/data/repositories/conversations_list_repo/drift_cached_conversations_list_repo.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/data.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/repositories/media_download_cache_repo/drift_media_download_cache_repo.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/repositories/media_download_cache_repo/i_media_download_cache_repo.dart';
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

  ISessionCacheRepo get _sessionCacheRepo =>
      LocalSessionCacheRepo(storage: _appScope.storageAggregator.secureStorage);

  AppDatabase get _db => _appScope.db;

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
    return DriftCachedConversationsListRepo(
      network: HttpConversationsListRepo(
        httpClient: _httpClient,
        apiConfig: _appScope.apiConfig,
        sessionCacheRepo: _sessionCacheRepo,
        logger: _appScope.logger,
      ),
      tilesDao: _db.conversationTilesDao,
    );
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
    return HttpPrivateMessageRepo(httpClient: _httpClient);
  }

  @override
  IMediaRepo createMediaRepo() {
    return HttpMediaRepo(httpClient: _httpClient);
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
    return DriftCachedPrivateConversationRepo(
      network: HttpPrivateConversationRepo(
        httpClient: _httpClient,
        apiConfig: _appScope.apiConfig,
        sessionCacheRepo: _sessionCacheRepo,
        logger: _appScope.logger,
      ),
      messagesDao: _db.privateMessagesDao,
    );
  }

  @override
  IMediaDownloadCacheRepo createMediaDownloadCacheRepo() =>
      DriftMediaDownloadCacheRepo(dao: _db.mediaDownloadCacheDao);

  @override
  IUserRepo createUserRepo() {
    return HttpUserRepo(httpClient: _httpClient);
  }

  @override
  ISessionCacheRepo createSessionCacheRepo() {
    return _sessionCacheRepo;
  }

  @override
  IUserCacheRepo createUserCacheRepo() {
    return LocalUserCacheRepo(
      storage: _appScope.storageAggregator.localKeyValueStorage,
    );
  }

  @override
  IDeviceInfoRepo createDeviceInfoRepo() {
    return createPlatformDeviceInfoRepo();
  }

  @override
  IUnifiedSearchRepo createUnifiedSearchRepo() {
    return HttpUnifiedSearchRepo(httpClient: _httpClient);
  }
}
