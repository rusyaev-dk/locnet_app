import 'package:flutter/material.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';

class PrivateConversationLoadingShimmer extends StatelessWidget {
  const PrivateConversationLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConversationLoadingShimmer();
  }
}
