import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/domain/domain.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/media/domain/interactors/media_interactor.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/blocs/message_attachments_cubit/platform_file_bytes.dart'
    if (dart.library.html)
      'package:locnet_app/features/message/subfeatures/message_input/presentation/blocs/message_attachments_cubit/platform_file_bytes_stub.dart';
import 'package:locnet_app/features/settings/subfeatures/profile/domain/profile_interactor.dart';

part 'profile_editor_state.dart';

class ProfileEditorCubit extends Cubit<ProfileEditorState> {
  ProfileEditorCubit({
    required ProfileInteractor profileInteractor,
    required AuthInteractor authInteractor,
    required AuthCubit authCubit,
    required MediaInteractor mediaInteractor,
    required ILogger logger,
  }) : _profileInteractor = profileInteractor,
       _authInteractor = authInteractor,
       _authCubit = authCubit,
       _mediaInteractor = mediaInteractor,
       _logger = logger,
       super(const ProfileEditorState());

  final ProfileInteractor _profileInteractor;
  final AuthInteractor _authInteractor;
  final AuthCubit _authCubit;
  final MediaInteractor _mediaInteractor;
  final ILogger _logger;

  /// Raw (pre-crop) image bytes waiting for the crop modal.
  /// Kept outside state to avoid expensive equality checks on large byte arrays.
  Uint8List? _pendingAvatarBytes;
  String _pendingAvatarFileName = 'avatar.jpg';

  Uint8List? get pendingAvatarBytes => _pendingAvatarBytes;

  // ── Profile loading ──────────────────────────────────────────────────────

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, failure: null));
    try {
      final User loadedUser = await _profileInteractor.loadUserData();
      emit(
        state.copyWith(
          isLoading: false,
          user: loadedUser,
          isEditing: false,
          isSubmitting: false,
          firstName: loadedUser.firstName,
          lastName: loadedUser.lastName,
          username: loadedUser.username,
          description: loadedUser.description ?? '',
          firstNameException: null,
          lastNameException: null,
          usernameException: null,
          failure: null,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      emit(state.copyWith(isLoading: false, failure: appException));
    }
  }

  // ── Profile editing ──────────────────────────────────────────────────────

  void startEditing() {
    final User? user = state.user;
    if (user == null) return;
    emit(
      state.copyWith(
        isEditing: true,
        firstName: user.firstName,
        lastName: user.lastName,
        username: user.username,
        description: user.description ?? '',
        firstNameException: null,
        lastNameException: null,
        usernameException: null,
        failure: null,
      ),
    );
  }

  void cancelEditing() {
    final User? user = state.user;
    if (user == null) return;
    emit(
      state.copyWith(
        isEditing: false,
        isSubmitting: false,
        firstName: user.firstName,
        lastName: user.lastName,
        username: user.username,
        description: user.description ?? '',
        firstNameException: null,
        lastNameException: null,
        usernameException: null,
        failure: null,
      ),
    );
  }

  void updateFirstName({required String? value}) {
    try {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        emit(
          state.copyWith(
            firstName: normalized,
            firstNameException: RequiredValueNotProvidedException(
              message: 'Firstname cannot be empty',
            ),
          ),
        );
        return;
      }
      try {
        ProfileDataValidator.validateName(normalized);
      } catch (e) {
        emit(state.copyWith(firstName: normalized, firstNameException: e));
        return;
      }
      emit(state.copyWith(firstName: normalized, firstNameException: null));
    } catch (e, st) {
      _emitUnknownFailure(error: e, stackTrace: st);
    }
  }

  void updateLastName({required String? value}) {
    try {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        emit(
          state.copyWith(
            lastName: normalized,
            lastNameException: RequiredValueNotProvidedException(
              message: 'Lastname cannot be empty',
            ),
          ),
        );
        return;
      }
      try {
        ProfileDataValidator.validateName(normalized);
      } catch (e) {
        emit(state.copyWith(lastName: normalized, lastNameException: e));
        return;
      }
      emit(state.copyWith(lastName: normalized, lastNameException: null));
    } catch (e, st) {
      _emitUnknownFailure(error: e, stackTrace: st);
    }
  }

  void updateUsername({required String? value}) {
    try {
      final String normalized = value?.trim() ?? '';
      if (normalized.isEmpty) {
        emit(
          state.copyWith(
            username: normalized,
            usernameException: RequiredValueNotProvidedException(
              message: 'Username cannot be empty',
            ),
          ),
        );
        return;
      }
      try {
        ProfileDataValidator.validateUsername(normalized);
      } catch (e) {
        emit(state.copyWith(username: normalized, usernameException: e));
        return;
      }
      emit(state.copyWith(username: normalized, usernameException: null));
    } catch (e, st) {
      _emitUnknownFailure(error: e, stackTrace: st);
    }
  }

  void updateDescription({required String? value}) {
    emit(state.copyWith(description: value?.trim() ?? ''));
  }

  Future<void> submitChanges() async {
    final User? currentUser = state.user;
    if (currentUser == null || state.isSubmitting) return;

    final String firstName = (state.firstName ?? '').trim();
    final String lastName = (state.lastName ?? '').trim();
    final String username = (state.username ?? '').trim();
    final String description = (state.description ?? '').trim();

    updateFirstName(value: firstName);
    updateLastName(value: lastName);
    updateUsername(value: username);

    if (state.firstNameException != null ||
        state.lastNameException != null ||
        state.usernameException != null) {
      return;
    }

    emit(state.copyWith(isSubmitting: true, failure: null));
    try {
      if (username != currentUser.username) {
        final bool isAvailable = await _authInteractor.validateRegisterLogin(
          login: username,
        );
        if (!isAvailable) {
          emit(
            state.copyWith(
              isSubmitting: false,
              usernameException: AuthLoginAlreadyTakenException(
                message: 'Username already taken',
              ),
            ),
          );
          return;
        }
      }

      final User updatedUser = currentUser.copyWith(
        firstName: firstName,
        lastName: lastName,
        username: username,
        description: description.isEmpty ? null : description,
      );
      final User savedUser = await _profileInteractor.udpateUserData(
        updatedUser: updatedUser,
      );
      await _authCubit.syncAuthenticatedUser(savedUser);
      emit(
        state.copyWith(
          user: savedUser,
          firstName: savedUser.firstName,
          lastName: savedUser.lastName,
          username: savedUser.username,
          description: savedUser.description ?? '',
          isEditing: false,
          isSubmitting: false,
          firstNameException: null,
          lastNameException: null,
          usernameException: null,
          failure: null,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      emit(state.copyWith(isSubmitting: false, failure: appException));
    }
  }

  // ── Avatar: pick (shows crop next) ──────────────────────────────────────

  Future<void> pickImageForAvatar() async {
    if (state.isUploadingAvatar) return;

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: kIsWeb,
      );
      if (result == null || result.files.isEmpty) return;

      final PlatformFile platformFile = result.files.first;
      final Uint8List? rawBytes = await resolvePlatformFileBytes(
        bytes: platformFile.bytes,
        path: platformFile.path,
      );
      if (rawBytes == null || rawBytes.isEmpty) return;

      _pendingAvatarFileName =
          '${platformFile.name.replaceAll(RegExp(r'\.[^.]+$'), '')}.png';

      // Resize to ≤ 2048×2048 before cropping.
      final Uint8List constrained = await _constrainImageTo2048(rawBytes);
      _pendingAvatarBytes = constrained;
      emit(state.copyWith(hasPendingAvatar: true, failure: null));
    } catch (e, st) {
      _logger.exception(e, st);
      _pendingAvatarBytes = null;
    }
  }

  /// Called when the user dismisses the crop modal without confirming.
  void cancelAvatarPick() {
    _pendingAvatarBytes = null;
    emit(state.copyWith(hasPendingAvatar: false));
  }

  // ── Avatar: upload after crop ────────────────────────────────────────────

  /// Upload [croppedBytes] (PNG from the crop modal) as the new avatar.
  Future<void> uploadAvatarBytes({required Uint8List croppedBytes}) async {
    final User? currentUser = state.user;
    if (currentUser == null || state.isUploadingAvatar) return;

    _pendingAvatarBytes = null;
    emit(
      state.copyWith(
        hasPendingAvatar: false,
        isUploadingAvatar: true,
        failure: null,
      ),
    );

    try {
      final String fileName = _pendingAvatarFileName.endsWith('.png')
          ? _pendingAvatarFileName
          : 'avatar.png';

      final mediaInit = await _mediaInteractor.initUpload(
        scope: 'user_profile',
        scopeId: currentUser.userId,
        fileName: fileName,
        mimeType: 'image/png',
        sizeBytes: croppedBytes.length,
      );

      final String? etag = await _mediaInteractor.uploadBytes(
        uploadUrl: mediaInit.uploadUrl,
        bytes: croppedBytes,
        requiredHeaders: mediaInit.requiredHeaders,
      );

      final mediaComplete = await _mediaInteractor.completeUpload(
        mediaId: mediaInit.mediaId,
        etag: etag,
        contentLength: croppedBytes.length,
      );

      // Build updated user with new avatarId.
      final User updatedUser = User(
        userId: currentUser.userId,
        username: currentUser.username,
        firstName: currentUser.firstName,
        lastName: currentUser.lastName,
        patronymic: currentUser.patronymic,
        languageCode: currentUser.languageCode,
        description: currentUser.description,
        avatarId: mediaComplete.mediaId,
        isDeleted: currentUser.isDeleted,
        isBanned: currentUser.isBanned,
        createdAt: currentUser.createdAt,
        updatedAt: currentUser.updatedAt,
      );
      final User savedUser = await _profileInteractor.udpateUserData(
        updatedUser: updatedUser,
      );
      await _authCubit.syncAuthenticatedUser(savedUser);

      emit(
        state.copyWith(
          user: savedUser,
          isUploadingAvatar: false,
          failure: null,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      emit(state.copyWith(isUploadingAvatar: false, failure: appException));
    }
  }

  // ── Avatar: delete ───────────────────────────────────────────────────────

  Future<void> deleteAvatar() async {
    final User? currentUser = state.user;
    if (currentUser == null || currentUser.avatarId == null) return;
    if (state.isUploadingAvatar) return;

    emit(state.copyWith(isUploadingAvatar: true, failure: null));
    try {
      final User updatedUser = User(
        userId: currentUser.userId,
        username: currentUser.username,
        firstName: currentUser.firstName,
        lastName: currentUser.lastName,
        patronymic: currentUser.patronymic,
        languageCode: currentUser.languageCode,
        description: currentUser.description,
        avatarId: null,
        isDeleted: currentUser.isDeleted,
        isBanned: currentUser.isBanned,
        createdAt: currentUser.createdAt,
        updatedAt: currentUser.updatedAt,
      );
      final User savedUser = await _profileInteractor.udpateUserData(
        updatedUser: updatedUser,
      );
      await _authCubit.syncAuthenticatedUser(savedUser);
      emit(
        state.copyWith(
          user: savedUser,
          isUploadingAvatar: false,
          failure: null,
        ),
      );
    } catch (e, st) {
      _logger.exception(e, st);
      final AppException appException = e is AppException
          ? e
          : AppUnknownException(
              message: e.toString(),
              error: e,
              stackTrace: st,
            );
      emit(state.copyWith(isUploadingAvatar: false, failure: appException));
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Resize [bytes] so neither dimension exceeds 2048 px.
  Future<Uint8List> _constrainImageTo2048(Uint8List bytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Image image = frame.image;
    final int w = image.width;
    final int h = image.height;
    image.dispose();
    codec.dispose();

    const int maxDim = 2048;
    if (w <= maxDim && h <= maxDim) {
      return bytes;
    }

    final int longerSide = max(w, h);
    final int targetW = (w * maxDim / longerSide).round();
    final int targetH = (h * maxDim / longerSide).round();

    final ui.Codec scaledCodec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: targetW,
      targetHeight: targetH,
    );
    final ui.FrameInfo scaledFrame = await scaledCodec.getNextFrame();
    final ui.Image scaledImage = scaledFrame.image;
    scaledCodec.dispose();

    final ByteData? byteData = await scaledImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    scaledImage.dispose();

    if (byteData == null) return bytes;
    return byteData.buffer.asUint8List();
  }

  void _emitUnknownFailure({
    required Object error,
    required StackTrace stackTrace,
  }) {
    _logger.exception(error, stackTrace);
    final AppException appException = error is AppException
        ? error
        : AppUnknownException(
            message: error.toString(),
            error: error,
            stackTrace: stackTrace,
          );
    emit(state.copyWith(failure: appException));
  }
}
