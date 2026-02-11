// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/subfeatures/channel/channel.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/mock/mock.dart';

final class MockChannelRepo implements IChannelRepo {
  MockChannelRepo({required MockInMemoryBackend backendStorage})
    : _backendStorage = backendStorage;

  final MockInMemoryBackend _backendStorage;

  @override
  Future<Channel> getChannel({required String channelId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final dto = _backendStorage.getChannelById(channelId);
    return Channel.fromDto(dto);
  }

  @override
  Future<Channel> createChannel({
    required String creatorId,
    required List<String> subscribersIds,
    required String title,
    String? description,
    String? avatarFileId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement channel creation
    throw UnimplementedError();
  }

  @override
  Future<Channel> updateChannel({required Channel updatedChannel}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final updatedDto = _backendStorage.updateChannel(updatedChannel);
    return Channel.fromDto(updatedDto);
  }

  @override
  Future<bool> deleteChannel({required String channelId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _backendStorage.deleteChannel(channelId: channelId);
  }

  @override
  Future<bool> toggleNotifications({
    required String channelId,
    required bool newNotificationsStatus,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<List<User>> loadChannelSubscribers({required String channelId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final userDtos = _backendStorage.getChannelSubscribers(channelId: channelId);
    return userDtos.map(User.fromDto).toList();
  }

  @override
  Future<bool> addUserToChannel({
    required String channelId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement add user to channel
    return true;
  }

  @override
  Future<bool> banUserFromChannel({
    required String channelId,
    required String reason,
    required String userId,
    required String bannedByUserId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement ban user from channel
    return true;
  }

  @override
  Future<bool> deleteUserFromChannel({
    required String channelId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // TODO: Implement delete user from channel
    return true;
  }

  @override
  Future<List<ChannelPublication>> loadPublications({
    required String channelId,
    int page = 1,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final int safePage = page <= 0 ? 1 : page;

    final List<ChannelPublicationDto> dtos = _backendStorage
        .getAllChannelPublicationsByChannelId(
          channelId: channelId,
          page: safePage,
        );

    final List<ChannelPublication> result = <ChannelPublication>[];

    for (final ChannelPublicationDto dto in dtos) {
      if (dto.isDeleted) {
        continue;
      }
      result.add(ChannelPublication.fromDto(dto));
    }

    return result;
  }

  @override
  Future<ChannelPublication> sendPublication({
    required ChannelPublication publication,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    final resDto = _backendStorage.addChannelPublication(
      newPublication: publication,
    );

    return publication.copyWith(
      publicationId: resDto.publicationId,
      deliveryStatus: MessageDeliveryStatus.sent,
      attachments: publication.attachments
          .map(
            (a) => a.copyWith(publicationId: resDto.publicationId),
          )
          .toList(),
    );
  }

  @override
  Future<ChannelPublication> editPublication({
    required ChannelPublication updatedPublication,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final storedDto = _backendStorage.updateChannelPublication(
      updatedPublication: updatedPublication,
    );
    return ChannelPublication.fromDto(storedDto);
  }

  @override
  Future<bool> deletePublication({
    required ChannelPublication publication,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _backendStorage.deleteChannelPublication(publication: publication);
  }
}
