import 'package:locnet_app/features/conversation/subfeatures/channel/domain/models/channel_publication.dart';

enum ChannelPublicationUpdateType { created, updated, deleted }

typedef ChannelPublicationUpdateRec = ({
  ChannelPublicationUpdateType updateType,
  ChannelPublication publication,
});
