import 'package:flutter/material.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/presentation.dart';
import 'package:locnet_app/features/message/domain/domain.dart';

class PrivateMessagesList extends StatelessWidget {
  const PrivateMessagesList({
    required this.messages,
    required this.companionId,
    super.key,
  });

  final List<Message> messages;
  final String companionId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: messages.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 4);
      },
      itemBuilder: (BuildContext context, int index) {
        final Message message = messages[index];
        return PrivateMessageBubble(message: message, companionId: companionId);
      },
    );
  }
}
