import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<QueryExecutor> openNativeEncryptedExecutor(String encryptionKey) async {
  final dir = await getApplicationSupportDirectory();

  // await _deleteLegacyPlaintextCacheFiles();

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

/// Удаляет старый незашифрованный файл БД от drift_flutter при первом запуске.
// Future<void> _deleteLegacyPlaintextCacheFiles() async {
//   final docsDir = await getApplicationDocumentsDirectory();
//   final legacyBase = p.join(docsDir.path, 'locnet_app_cache');

//   for (final suffix in ['.sqlite', '.sqlite-wal', '.sqlite-shm']) {
//     final f = File(legacyBase + suffix);
//     if (await f.exists()) {
//       try {
//         await f.delete();
//       } catch (_) {}
//     }
//   }

//   final oldEncrypted = File(
//     p.join(docsDir.path, 'locnet_app_cache_encrypted.sqlite'),
//   );
//   if (await oldEncrypted.exists()) {
//     try {
//       await oldEncrypted.delete();
//     } catch (_) {}
//   }
// }
