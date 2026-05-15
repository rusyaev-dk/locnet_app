import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/models/models.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/repositories/unified_search_repo/i_unified_search_repo.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/domain/domain.dart';

class HttpUnifiedSearchRepo implements IUnifiedSearchRepo {
  HttpUnifiedSearchRepo({required IHttpClient httpClient})
    : _httpClient = httpClient;

  final IHttpClient _httpClient;

  @override
  Future<UnifiedSearchResult> search({
    required String query,
    int page = 1,
  }) async {
    try {
      final int safePage = page <= 0 ? 1 : page;
      final httpResponse = await _httpClient.get(
        path: ApiEndpoints.unifiedSearch,
        uriParameters: <String, dynamic>{
          'q': query,
          'page': safePage.toString(),
        },
      );

      final dynamic responseData = httpResponse.data;
      if (responseData is! Map<String, dynamic>) {
        throw AppUnknownException(
          message: 'Invalid unified search response format',
          error: responseData,
          stackTrace: StackTrace.current,
        );
      }

      final UnifiedSearchResultDto dto = UnifiedSearchResultDto.fromJson(
        responseData,
      );
      return UnifiedSearchResult.fromDto(dto);
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw AppUnknownException(
        message: 'Failed unified search',
        error: e,
        stackTrace: st,
      );
    }
  }
}
