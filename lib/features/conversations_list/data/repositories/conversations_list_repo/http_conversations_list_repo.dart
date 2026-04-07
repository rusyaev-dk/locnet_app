import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations_list/data/data.dart';
import 'package:locnet_app/features/conversations_list/domain/models/conversation_tile.dart';

class HttpConversationsListRepo implements IConversationsListRepo {
  HttpConversationsListRepo({required IHttpClient httpClient})
    : _httpClient = httpClient;

  final IHttpClient _httpClient;

  @override
  Stream<ConversationsListUpdateRec> get conversationsUpdates =>
      throw UnimplementedError();

  @override
  Future<List<ConversationTile>> loadConversationsList({int page = 1}) async {
    try {
      final int safePage = page <= 0 ? 1 : page;
      final httpResponse = await _httpClient.get(
        path: ApiEndpoints.privateConversations,
        uriParameters: <String, dynamic>{'page': safePage.toString()},
      );

      final dynamic responseData = httpResponse.data;
      if (responseData is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid API response format',
          error: responseData,
          stackTrace: StackTrace.current,
        );
      }

      final Map<String, dynamic> responseJson = responseData;
      final dynamic rawTiles = responseJson['tiles'];
      if (rawTiles is! List) {
        return <ConversationTile>[];
      }

      final List<ConversationTile> conversations = <ConversationTile>[];
      for (final dynamic conversationRaw in rawTiles) {
        if (conversationRaw is! Map<String, dynamic>) {
          continue;
        }

        final ConversationTileDto conversationDto = ConversationTileDto.fromJson(
          conversationRaw,
        );
        conversations.add(ConversationTile.fromDto(conversationDto));
      }

      return conversations;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed to load conversations list',
        error: e,
        stackTrace: st,
      );
    }
  }
}
