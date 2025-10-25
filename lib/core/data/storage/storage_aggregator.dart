import 'package:locnet_app/core/data/storage/storage.dart';

class StorageAggregator {
  StorageAggregator({
    required this.secureStorage,
    required this.sharedPrefsStorage,
  });

  final IKeyValueStorage secureStorage;
  final IKeyValueStorage sharedPrefsStorage;

  IKeyValueStorage get secure => secureStorage;
  IKeyValueStorage get prefs => sharedPrefsStorage;
}
