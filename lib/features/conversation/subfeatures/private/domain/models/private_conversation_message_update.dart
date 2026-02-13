import 'package:locnet_app/features/conversation/subfeatures/private/domain/models/private_message.dart';

enum PrivateConversationMessageUpdateType { created, updated, deleted }

typedef PrivateConversationMessageUpdateRec = ({
  PrivateConversationMessageUpdateType updateType,
  PrivateMessage message,
});
