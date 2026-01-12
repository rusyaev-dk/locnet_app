import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/data/data.dart';
import 'package:locnet_app/di/di.dart';
import 'package:locnet_app/features/auth/data/data.dart';
import 'package:locnet_app/features/conversation/data/repositories/repositories.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/data/repositories/channel_repo/i_channel_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/group/data/repositories/group_conversation_repo/i_group_conversation_repo.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/repositories/private_conversation_repo/i_private_conversation_repo.dart';
import 'package:locnet_app/features/conversations/data/data.dart';
import 'package:locnet_app/features/message/data/repositories/message_repo/i_message_repo.dart';
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

  @override
  IAuthRepo createAuthRepo() {
    return const MockAuthRepo();
  }

  @override
  ISettingsRepo createSettingsRepo() {
    return LocalSettingsRepo(
      storage: _appScope.storageAggregator.localKeyValueStorage,
    );
  }

  @override
  IThemeEditorRepo createThemeEditorRepo() {
    return MockThemeEditorRepo();
  }

  @override
  IConversationsListRepo createConversationsListRepo() {
    return MockConversationsListRepo(backendStorage: _mockInMemoryBackend);
  }

  @override
  IChannelRepo createChannelRepo() {
    throw UnimplementedError();
  }

  @override
  IConversationRepo createConversationRepo() {
    return MockConversationRepo(backendStorage: _mockInMemoryBackend);
  }

  @override
  IGroupConversationRepo createGroupConversationRepo() {
    throw UnimplementedError();
  }

  @override
  IMessageRepo createMessageRepo() {
    throw UnimplementedError();
  }

  @override
  IPrivateConversationRepo createPrivateConversationRepo() {
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
}
