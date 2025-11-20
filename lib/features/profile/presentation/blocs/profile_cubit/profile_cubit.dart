import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/profile/domain/domain.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ProfileInteractor profileInteractor,
    required ILogger logger,
  }) : _profileInteractor = profileInteractor,
       _logger = logger,
       super(const ProfileInitialState());

  final ProfileInteractor _profileInteractor;
  final ILogger _logger;

  Future<void> loadUserData() async {
    try {
      if (state is! ProfileLoadingState) {
        emit(const ProfileLoadingState());
      }

      final user = await _profileInteractor.loadUserData();
      emit(ProfileLoadedState(user: user));
    } catch (e, st) {
      _logger.exception(e, st);
      emit(
        ProfileFailureState(
          failure: e is AppException
              ? e
              : AppUnknownException(message: e.toString(), stackTrace: st),
        ),
      );
    }
  }
}
