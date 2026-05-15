import 'package:locnet_app/features/conversations_list/subfeatures/unified_search/domain/domain.dart';

abstract interface class IUnifiedSearchRepo {
  Future<UnifiedSearchResult> search({required String query, int page = 1});
}
