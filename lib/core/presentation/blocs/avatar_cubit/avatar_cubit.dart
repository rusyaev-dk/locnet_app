import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/subfeatures/media/domain/interactors/media_interactor.dart';

part 'avatar_state.dart';

class AvatarCubit extends Cubit<AvatarState> {
  AvatarCubit({required MediaInteractor mediaInteractor})
    : _mediaInteractor = mediaInteractor,
      super(const AvatarInitialState());

  final MediaInteractor _mediaInteractor;

  Future<void> resolve(String? avatarId) async {
    if (avatarId == null || avatarId.trim().isEmpty) {
      emit(const AvatarEmptyState());
      return;
    }

    emit(const AvatarLoadingState());

    try {
      final info = await _mediaInteractor.getDownloadInfo(mediaId: avatarId);
      emit(AvatarLoadedState(url: info.downloadUrl));
    } catch (_) {
      emit(const AvatarEmptyState());
    }
  }
}
