import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';

import 'package:locnet_app/features/message/subfeatures/message_input/presentation/blocs/message_attachments_cubit/platform_file_bytes.dart'
    if (dart.library.html)
      'package:locnet_app/features/message/subfeatures/message_input/presentation/blocs/message_attachments_cubit/platform_file_bytes_stub.dart';

part 'message_attachments_state.dart';

class MessageAttachmentsCubit extends Cubit<MessageAttachmentsState> {
  MessageAttachmentsCubit()
    : super(
        const MessageAttachmentsState(
          files: <UploadableFile>[],
          isPicking: false,
        ),
      );

  Future<void> pickFiles() async {
    emit(state.copyWith(isPicking: true));

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const <String>[
          'jpg',
          'jpeg',
          'png',
          'gif',
          'webp',
          'heic',
          'heif',
          'mp4',
          'mov',
          'avi',
          'mkv',
          'webm',
          'mp3',
          'aac',
          'wav',
          'ogg',
          'm4a',
          'flac',
          'pdf',
          'doc',
          'docx',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
          'txt',
          'rtf',
        ],
        allowMultiple: true,
        // Web needs bytes in-memory; desktop often returns null bytes unless read from path.
        withData: kIsWeb,
      );

      if (result == null) {
        emit(state.copyWith(isPicking: false));
        return;
      }

      final List<UploadableFile> newFiles = <UploadableFile>[];

      for (final PlatformFile platformFile in result.files) {
        final Uint8List? fileBytes = await resolvePlatformFileBytes(
          bytes: platformFile.bytes,
          path: platformFile.path,
        );

        if (fileBytes == null || fileBytes.isEmpty) {
          continue;
        }

        final UploadableFileType fileType = _mapExtensionToFileType(
          platformFile.extension,
        );

        final UploadableFile uploadableFile = UploadableFile.fromBytes(
          fileName: platformFile.name,
          bytes: fileBytes,
          fileType: fileType,
        );

        newFiles.add(uploadableFile);
      }

      if (newFiles.isEmpty) {
        emit(state.copyWith(isPicking: false));
        return;
      }

      final List<UploadableFile> mergedFiles = <UploadableFile>[
        ...state.files,
        ...newFiles,
      ];

      emit(state.copyWith(files: mergedFiles, isPicking: false));
    } catch (e) {
      emit(
        state.copyWith(isPicking: false, errorMessage: 'Failed to pick files'),
      );
    }
  }

  void removeFile(UploadableFile file) {
    final List<UploadableFile> updatedFiles = List<UploadableFile>.from(
      state.files,
    )..remove(file);

    emit(state.copyWith(files: updatedFiles));
  }

  void clear() {
    emit(state.copyWith(files: <UploadableFile>[]));
  }

  void setFiles(List<UploadableFile> files) {
    emit(state.copyWith(files: List<UploadableFile>.from(files)));
  }

  void applyNewOrder(List<UploadableFile> files) {
    emit(state.copyWith(files: List<UploadableFile>.from(files)));
  }

  UploadableFileType _mapExtensionToFileType(String? extension) {
    if (extension == null || extension.isEmpty) {
      return UploadableFileType.file;
    }

    final String normalizedExtension = extension.toLowerCase();

    const List<String> imageExtensions = <String>[
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'heic',
      'heif',
    ];

    const List<String> videoExtensions = <String>[
      'mp4',
      'mov',
      'avi',
      'mkv',
      'webm',
    ];

    const List<String> audioExtensions = <String>[
      'mp3',
      'aac',
      'wav',
      'ogg',
      'm4a',
      'flac',
    ];

    const List<String> docExtensions = <String>[
      'pdf',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'txt',
      'rtf',
    ];

    if (imageExtensions.contains(normalizedExtension)) {
      return UploadableFileType.image;
    }
    if (videoExtensions.contains(normalizedExtension)) {
      return UploadableFileType.video;
    }
    if (audioExtensions.contains(normalizedExtension)) {
      return UploadableFileType.audio;
    }
    if (docExtensions.contains(normalizedExtension)) {
      return UploadableFileType.doc;
    }

    return UploadableFileType.file;
  }
}
