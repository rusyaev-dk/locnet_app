// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/models/media_metadata_dto.dart';

class MediaDeleteResponseDto extends Equatable {
  const MediaDeleteResponseDto({required this.deleted, required this.metadata});

  final bool deleted;
  final MediaMetadataDto? metadata;

  factory MediaDeleteResponseDto.fromJson(Map<String, Object?> json) {
    final Object? metadataRaw = json['metadata'];
    return MediaDeleteResponseDto(
      deleted: (json['deleted'] ?? false) as bool,
      metadata: metadataRaw is Map<String, Object?>
          ? MediaMetadataDto.fromJson(metadataRaw)
          : null,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'deleted': deleted,
      'metadata': metadata?.toJson(),
    };
  }

  MediaDeleteResponseDto copyWith({bool? deleted, MediaMetadataDto? metadata}) {
    return MediaDeleteResponseDto(
      deleted: deleted ?? this.deleted,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => <Object?>[deleted, metadata];
}
