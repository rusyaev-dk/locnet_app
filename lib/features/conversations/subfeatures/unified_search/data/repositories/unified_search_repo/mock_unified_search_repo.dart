import 'package:locnet_app/features/conversations/subfeatures/unified_search/data/data.dart';
import 'package:locnet_app/features/conversations/subfeatures/unified_search/domain/models/unified_search_result.dart';
import 'package:locnet_app/mock/mock.dart';

class MockUnifiedSearchRepo implements IUnifiedSearchRepo {
  MockUnifiedSearchRepo({required MockInMemoryBackend backend})
    : _backend = backend;

  final MockInMemoryBackend _backend;

  @override
  Future<UnifiedSearchResult> search({
    required String query,
    int page = 1,
  }) async {
    final dto = _backend.unifiedSearch(query: query);
    return UnifiedSearchResult.fromDto(dto);
  }
}
