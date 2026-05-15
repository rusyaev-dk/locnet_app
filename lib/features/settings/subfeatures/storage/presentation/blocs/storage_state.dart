sealed class StorageState {}

final class StorageLoadingState extends StorageState {}

final class StorageClearingState extends StorageState {
  StorageClearingState({required this.prevStats});
  final StorageLoadedState prevStats;
}

final class StorageLoadedState extends StorageState {
  StorageLoadedState({
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

  int get totalBytes =>
      photoBytes + videoBytes + audioBytes + textBytes + otherBytes;

  bool get isEmpty => totalBytes == 0;

  double fractionOf(int bytes) =>
      totalBytes == 0 ? 0.0 : bytes / totalBytes;
}

final class StorageErrorState extends StorageState {
  StorageErrorState({required this.error});
  final Object error;
}
