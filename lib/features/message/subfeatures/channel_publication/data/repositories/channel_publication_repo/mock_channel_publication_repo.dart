// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/features/conversation/subfeatures/channel/domain/domain.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/channel_publication/data/repositories/channel_publication_repo/i_channel_publication_repo.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockChannelPublicationRepo implements IChannelPublicationRepo {
  MockChannelPublicationRepo({
    required MockInMemoryBackend backendStorage,
    required StreamController<ChannelPublicationUpdateRec>
        publicationsUpdatesController,
  }) : _backendStorage = backendStorage,
       _publicationsUpdatesController = publicationsUpdatesController;

  final MockInMemoryBackend _backendStorage;
  final StreamController<ChannelPublicationUpdateRec>
      _publicationsUpdatesController;

  @override
  Future<ChannelPublication> sendPublication({
    required ChannelPublication publication,
  }) async {
    _publicationsUpdatesController.add((
      updateType: ChannelPublicationUpdateType.created,
      publication: publication,
    ));
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final dto = _backendStorage.addChannelPublication(
      newPublication: publication,
    );
    final sentPublication = publication.copyWith(
      publicationId: dto.publicationId,
      deliveryStatus: MessageDeliveryStatus.sent,
    );
    _publicationsUpdatesController.add((
      updateType: ChannelPublicationUpdateType.created,
      publication: sentPublication,
    ));
    return ChannelPublication.fromDto(dto);
  }

  @override
  Future<ChannelPublication> editPublication({
    required ChannelPublication updatedPublication,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final dto = _backendStorage.updateChannelPublication(
      updatedPublication: updatedPublication,
    );
    final storedPublication = ChannelPublication.fromDto(dto);
    _publicationsUpdatesController.add((
      updateType: ChannelPublicationUpdateType.updated,
      publication: storedPublication,
    ));
    return storedPublication;
  }

  @override
  Future<bool> deletePublication({
    required ChannelPublication publication,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final ok = _backendStorage.deleteChannelPublication(publication: publication);
    if (ok) {
      _publicationsUpdatesController.add((
        updateType: ChannelPublicationUpdateType.deleted,
        publication: publication.copyWith(isDeleted: true),
      ));
    }
    return ok;
  }

  @override
  Future<ChannelPublication> togglePublicationPin({
    required ChannelPublication publication,
    required bool isPinned,
  }) async {
    final updated = publication.copyWith(isPinned: isPinned);
    return editPublication(updatedPublication: updated);
  }
}

