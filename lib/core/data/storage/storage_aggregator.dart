import 'package:locnet_app/core/data/storage/db/db.dart';
import 'package:locnet_app/core/data/storage/storage.dart';

class StorageAggregator {
  StorageAggregator({
    required this.secureStorage,
    required this.localKeyValueStorage,
    required this.db,
  });

  final IKeyValueStorage secureStorage;
  final IKeyValueStorage localKeyValueStorage;
  final AppDatabase db;

  IKeyValueStorage get secure => secureStorage;
  IKeyValueStorage get prefs => localKeyValueStorage;
}
