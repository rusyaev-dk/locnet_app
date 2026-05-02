final class StorageCacheStats {
  const StorageCacheStats({
    required this.photoBytes,
    required this.videoBytes,
    required this.audioBytes,
    required this.textBytes,
    required this.otherBytes,
  });

  final int photoBytes;
  final int videoBytes;
  final int audioBytes;
  final int textBytes;
  final int otherBytes;
}
