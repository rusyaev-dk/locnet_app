// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/features/conversation/subfeatures/channel/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/channel_publication/data/repositories/channel_publication_repo/i_channel_publication_repo.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockChannelPublicationRepo implements IChannelPublicationRepo {
  MockChannelPublicationRepo({required MockInMemoryBackend backendStorage})
    : _backendStorage = backendStorage;

  final MockInMemoryBackend _backendStorage;

  @override
  Future<ChannelPublication> sendPublication({
    required ChannelPublication publication,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final dto = _backendStorage.addChannelPublication(
      newPublication: publication,
    );
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
    return ChannelPublication.fromDto(dto);
  }

  @override
  Future<bool> deletePublication({
    required ChannelPublication publication,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _backendStorage.deleteChannelPublication(publication: publication);
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

