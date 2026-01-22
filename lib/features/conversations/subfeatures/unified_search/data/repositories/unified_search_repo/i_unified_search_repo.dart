import 'package:locnet_app/features/conversations/subfeatures/unified_search/domain/domain.dart';

abstract interface class IUnifiedSearchRepo {
  Future<UnifiedSearchResult> search({required String query, int page = 1});
}
