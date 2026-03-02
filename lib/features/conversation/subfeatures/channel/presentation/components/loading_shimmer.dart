import 'package:flutter/material.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';

class ChannelConversationLoadingShimmer extends StatelessWidget {
  const ChannelConversationLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConversationLoadingShimmer();
  }
}
