import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/features/settings/subfeatures/storage/domain/settings_cache_database_interactor.dart';
import 'package:locnet_app/features/settings/subfeatures/storage/presentation/blocs/storage_state.dart';

class StorageCubit extends Cubit<StorageState> {
  StorageCubit({
    required SettingsCacheDatabaseInteractor cacheDatabaseInteractor,
  }) : _cacheDatabaseInteractor = cacheDatabaseInteractor,
       super(StorageLoadingState());

  final SettingsCacheDatabaseInteractor _cacheDatabaseInteractor;

  Future<void> loadStats() async {
    emit(StorageLoadingState());
    try {
      emit(await _fetchStats());
    } catch (e) {
      emit(StorageErrorState(error: e));
    }
  }

  Future<void> clearAll() async {
    final current = state;
    final prev = current is StorageLoadedState
        ? current
        : StorageLoadedState(
            photoBytes: 0,
            videoBytes: 0,
            audioBytes: 0,
            textBytes: 0,
            otherBytes: 0,
          );
    emit(StorageClearingState(prevStats: prev));
    try {
      await _cacheDatabaseInteractor.clearAll();
      emit(await _fetchStats());
    } catch (e) {
      emit(StorageErrorState(error: e));
    }
  }

  Future<StorageLoadedState> _fetchStats() async {
    final stats = await _cacheDatabaseInteractor.fetchStorageStats();
    return StorageLoadedState(
      photoBytes: stats.photoBytes,
      videoBytes: stats.videoBytes,
      audioBytes: stats.audioBytes,
      otherBytes: stats.otherBytes,
      textBytes: stats.textBytes,
    );
  }
}
