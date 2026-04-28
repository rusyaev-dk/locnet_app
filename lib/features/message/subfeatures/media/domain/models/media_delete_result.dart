// ignore_for_file: sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:locnet_app/features/message/subfeatures/media/data/models/media_delete_response_dto.dart';
import 'package:locnet_app/features/message/subfeatures/media/domain/models/media_metadata.dart';

class MediaDeleteResult extends Equatable {
  const MediaDeleteResult({required this.deleted, required this.metadata});

  final bool deleted;
  final MediaMetadata? metadata;

  factory MediaDeleteResult.fromDto(MediaDeleteResponseDto dto) {
    return MediaDeleteResult(
      deleted: dto.deleted,
      metadata: dto.metadata != null
          ? MediaMetadata.fromDto(dto.metadata!)
          : null,
    );
  }

  MediaDeleteResult copyWith({bool? deleted, MediaMetadata? metadata}) {
    return MediaDeleteResult(
      deleted: deleted ?? this.deleted,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => <Object?>[deleted, metadata];
}
