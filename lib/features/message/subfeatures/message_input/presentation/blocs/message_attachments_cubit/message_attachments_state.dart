part of 'message_attachments_cubit.dart';

class MessageAttachmentsState extends Equatable {
  const MessageAttachmentsState({
    required this.files,
    required this.isPicking,
    this.errorMessage,
  });

  final List<UploadableFile> files;
  final bool isPicking;
  final String? errorMessage;

  MessageAttachmentsState copyWith({
    List<UploadableFile>? files,
    bool? isPicking,
    String? errorMessage,
  }) {
    return MessageAttachmentsState(
      files: files ?? this.files,
      isPicking: isPicking ?? this.isPicking,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[files, isPicking, errorMessage];
}
