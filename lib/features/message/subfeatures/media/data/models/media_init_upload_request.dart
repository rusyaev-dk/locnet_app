import 'package:equatable/equatable.dart';

class MediaInitUploadRequestDto extends Equatable {
  const MediaInitUploadRequestDto({
    required this.scope,
    required this.scopeId,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    this.clientDedupeKey,
  });

  final String scope;
  final String scopeId;
  final String fileName;
  final String mimeType;
  final int sizeBytes;
  final String? clientDedupeKey;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'scope': scope,
      'scopeId': scopeId,
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (clientDedupeKey != null && clientDedupeKey!.isNotEmpty)
        'clientDedupeKey': clientDedupeKey,
    };
  }

  MediaInitUploadRequestDto copyWith({
    String? scope,
    String? scopeId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    String? clientDedupeKey,
  }) {
    return MediaInitUploadRequestDto(
      scope: scope ?? this.scope,
      scopeId: scopeId ?? this.scopeId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      clientDedupeKey: clientDedupeKey ?? this.clientDedupeKey,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    scope,
    scopeId,
    fileName,
    mimeType,
    sizeBytes,
    clientDedupeKey,
  ];
}
