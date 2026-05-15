import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<QueryExecutor> openNativeEncryptedExecutor(String encryptionKey) async {
  final dir = await getApplicationSupportDirectory();

  final file = File(p.join(dir.path, 'locnet_app_cache_encrypted.sqlite'));

  return NativeDatabase.createInBackground(
    file,
    setup: (db) {
      db
        ..execute("PRAGMA cipher = 'sqlcipher'")
        ..execute('PRAGMA legacy = 4')
        ..execute("PRAGMA key = '$encryptionKey'");
    },
  );
}
