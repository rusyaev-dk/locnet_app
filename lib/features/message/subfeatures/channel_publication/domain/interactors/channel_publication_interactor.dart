import 'package:locnet_app/features/conversation/subfeatures/channel/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/channel_publication/data/repositories/channel_publication_repo/i_channel_publication_repo.dart';

final class ChannelPublicationInteractor {
  ChannelPublicationInteractor({required IChannelPublicationRepo publicationRepo})
    : _publicationRepo = publicationRepo;

  final IChannelPublicationRepo _publicationRepo;

  Future<ChannelPublication> sendPublication({
    required ChannelPublication publication,
  }) async {
    return _publicationRepo.sendPublication(publication: publication);
  }

  Future<ChannelPublication> editPublication({
    required ChannelPublication updatedPublication,
  }) async {
    return _publicationRepo.editPublication(
      updatedPublication: updatedPublication,
    );
  }

  Future<bool> deletePublication({
    required ChannelPublication publication,
  }) async {
    return _publicationRepo.deletePublication(publication: publication);
  }

  Future<ChannelPublication> togglePublicationPin({
    required ChannelPublication publication,
    required bool isPinned,
  }) async {
    return _publicationRepo.togglePublicationPin(
      publication: publication,
      isPinned: isPinned,
    );
  }
}

