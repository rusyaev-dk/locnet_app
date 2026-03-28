import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/data/data.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/models/private_conversation.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/models/private_conversation_message_update.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/domain/models/private_message.dart';

class HttpPrivateConversationRepo implements IPrivateConversationRepo {
  HttpPrivateConversationRepo({required IHttpClient httpClient})
    : _httpClient = httpClient;

  final IHttpClient _httpClient;

  @override
  Future<bool> blockCompanion({
    required String companionId,
    required String blockedByUserId,
    required String reason,
  }) {
    // TODO: implement blockCompanion
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteConversation({
    required String conversationId,
    required bool deleteAtRecipient,
  }) async {
    try {
      await _httpClient.delete(
        path: ApiEndpoints.privateConversation(conversationId),
        uriParameters: <String, dynamic>{
          'deleteAtRecipient': deleteAtRecipient.toString(),
        },
      );
      return true;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to delete private conversation',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<User> getCompanion({required String conversationId}) {
    // TODO: implement getCompanion
    throw UnimplementedError();
  }

  @override
  Future<PrivateConversation> getPrivateConversation({
    required String conversationId,
  }) async {
    try {
      final httpResponse = await _httpClient.post(
        path: ApiEndpoints.privateConversations,
        data: <String, dynamic>{'conversationId': conversationId},
      );

      final dynamic data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }

      final dynamic rawConversation = data['conversation'] ?? data;
      if (rawConversation is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Conversation payload is missing',
          error: rawConversation,
          stackTrace: StackTrace.current,
        );
      }

      final Map<String, dynamic> normalizedConversationJson = <String, dynamic>{
        ...rawConversation,
        'conversationId':
            rawConversation['conversationId'] ?? rawConversation['id'],
        'user1': rawConversation['user1'] ?? rawConversation['user1Id'],
        'user2': rawConversation['user2'] ?? rawConversation['user2Id'],
      };

      final PrivateConversationDto conversationDto =
          PrivateConversationDto.fromJson(normalizedConversationJson);
      return PrivateConversation.fromDto(conversationDto);
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to load private conversation',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<List<PrivateMessage>> loadMessagesPage({
    required String conversationId,
    int page = 1,
  }) async {
    try {
      final int safePage = page <= 0 ? 1 : page;
      final httpResponse = await _httpClient.get(
        path: ApiEndpoints.privateConversationMessages(conversationId),
        uriParameters: <String, dynamic>{'page': safePage.toString()},
      );

      final dynamic data = httpResponse.data;
      if (data is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: data,
          stackTrace: StackTrace.current,
        );
      }

      final dynamic rawMessages = data['messages'] ?? data['items'] ?? data;
      if (rawMessages is! List) {
        return <PrivateMessage>[];
      }

      final List<PrivateMessage> messages = <PrivateMessage>[];

      for (final dynamic message in rawMessages) {
        if (message is! Map<String, dynamic>) {
          continue;
        }

        final PrivateMessageDto messageDto = PrivateMessageDto.fromJson(message);

        messages.add(PrivateMessage.fromDto(messageDto));
      }

      return messages;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to load private messages page',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  // TODO: implement messagesUpdates
  Stream<PrivateConversationMessageUpdateRec> get messagesUpdates =>
      throw UnimplementedError();

  @override
  Future<bool> toggleNotifications({
    required String conversationId,
    required bool newNotificationsStatus,
  }) {
    // TODO: implement toggleNotifications
    throw UnimplementedError();
  }
}
