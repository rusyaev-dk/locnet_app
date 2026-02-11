import 'package:locnet_app/features/conversation/subfeatures/channel/domain/domain.dart';

/// Repository for channel publications.
abstract interface class IChannelPublicationRepo {
  Future<ChannelPublication> sendPublication({
    required ChannelPublication publication,
  });

  Future<ChannelPublication> editPublication({
    required ChannelPublication updatedPublication,
  });

  Future<bool> deletePublication({
    required ChannelPublication publication,
  });

  Future<ChannelPublication> togglePublicationPin({
    required ChannelPublication publication,
    required bool isPinned,
  });
}

