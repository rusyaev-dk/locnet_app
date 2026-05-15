import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/data/data.dart';
import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/domain/domain.dart';

class UnifiedSearchInteractor {
  UnifiedSearchInteractor({required IUnifiedSearchRepo searchRepo})
    : _searchRepo = searchRepo;

  final IUnifiedSearchRepo _searchRepo;

  Future<UnifiedSearchResult> search({
    required String query,
    int page = 1,
  }) async {
    return await _searchRepo.search(query: query, page: page);
  }
}
