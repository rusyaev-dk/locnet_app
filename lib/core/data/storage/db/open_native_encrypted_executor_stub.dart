import 'package:drift/drift.dart';

Future<QueryExecutor> openNativeEncryptedExecutor(String encryptionKey) async {
  throw UnsupportedError(
    'openNativeEncryptedExecutor is only supported on native (VM) platforms',
  );
}
