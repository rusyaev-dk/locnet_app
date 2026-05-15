import 'package:locnet_app/features/conversation/subfeatures/group/domain/models/group_message.dart';

enum GroupConversationMessageUpdateType { created, updated, deleted }

typedef GroupConversationMessageUpdateRec = ({
  GroupConversationMessageUpdateType updateType,
  GroupMessage message,
});
