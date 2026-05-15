import 'dart:io';
import 'dart:typed_data';

/// Reads picked file bytes on IO platforms when [bytes] is null (common on desktop).
Future<Uint8List?> resolvePlatformFileBytes({
  required Uint8List? bytes,
  required String? path,
}) async {
  if (bytes != null) {
    return bytes;
  }
  if (path == null || path.isEmpty) {
    return null;
  }
  try {
    return await File(path).readAsBytes();
  } catch (_) {
    return null;
  }
}
