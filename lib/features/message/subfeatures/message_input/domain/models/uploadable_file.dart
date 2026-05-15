// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';

class UploadableFile extends Equatable {
  const UploadableFile({
    required this.fileName,
    required this.bytes,
    required this.sizeKb,
    required this.fileType,
  });

  final String fileName;
  final List<int> bytes;
  final int sizeKb;
  final UploadableFileType fileType;

  factory UploadableFile.fromBytes({
    required String fileName,
    required List<int> bytes,
    required UploadableFileType fileType,
  }) {
    final int sizeKb = (bytes.length / 1024).ceil();

    return UploadableFile(
      fileName: fileName,
      bytes: bytes,
      sizeKb: sizeKb,
      fileType: fileType,
    );
  }

  @override
  List<Object?> get props => <Object?>[fileName, sizeKb, fileType];
}
