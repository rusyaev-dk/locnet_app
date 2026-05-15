import 'package:flutter/material.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';

class GroupConversationLoadingShimmer extends StatelessWidget {
  const GroupConversationLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConversationLoadingShimmer();
  }
}
