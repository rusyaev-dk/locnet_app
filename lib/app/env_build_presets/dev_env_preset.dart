import 'dart:async';

import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/domain.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/repositories/repositories.dart';
import 'package:locnet_app/features/message/data/data.dart';
import 'package:locnet_app/features/settings/data/data.dart';
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

  StreamController<PrivateConversationMessageUpdateRec>?
      _privateMessagesUpdatesController;

  StreamController<PrivateConversationMessageUpdateRec>
      get _privateMessagesUpdates =>
      _privateMessagesUpdatesController ??=
          StreamController<PrivateConversationMessageUpdateRec>.broadcast();

  StreamController<GroupConversationMessageUpdateRec>?
      _groupMessagesUpdatesController;

  StreamController<GroupConversationMessageUpdateRec>
      get _groupMessagesUpdates =>
      _groupMessagesUpdatesController ??=
          StreamController<GroupConversationMessageUpdateRec>.broadcast();

  StreamController<ChannelPublicationUpdateRec>?
      _channelPublicationsUpdatesController;

  StreamController<ChannelPublicationUpdateRec>
      get _channelPublicationsUpdates =>
      _channelPublicationsUpdatesController ??=
          StreamController<ChannelPublicationUpdateRec>.broadcast();

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
    return MockChannelRepo(
      backendStorage: _mockInMemoryBackend,
      publicationsUpdatesController: _channelPublicationsUpdates,
    );
  }

  @override
  IGroupRepo createGroupConversationRepo() {
    return MockGroupRepo(
      backendStorage: _mockInMemoryBackend,
      messagesUpdatesController: _groupMessagesUpdates,
    );
  }

  @override
  IPrivateMessageRepo createPrivateMessageRepo() {
    return MockPrivateMessageRepo(
      backendStorage: _mockInMemoryBackend,
      messagesUpdatesController: _privateMessagesUpdates,
    );
  }

  @override
  IGroupMessageRepo createGroupMessageRepo() {
    return MockGroupMessageRepo(
      backendStorage: _mockInMemoryBackend,
      messagesUpdatesController: _groupMessagesUpdates,
    );
  }

  @override
  IChannelPublicationRepo createChannelPublicationRepo() {
    return MockChannelPublicationRepo(
      backendStorage: _mockInMemoryBackend,
      publicationsUpdatesController: _channelPublicationsUpdates,
    );
  }

  @override
  IPrivateConversationRepo createPrivateConversationRepo() {
    return MockPrivateConversationRepo(
      backendStorage: _mockInMemoryBackend,
      messagesUpdatesController: _privateMessagesUpdates,
    );
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
