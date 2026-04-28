import 'package:flutter/material.dart';

/// Shared loading indicator for any conversation type.
class ConversationLoadingShimmer extends StatelessWidget {
  const ConversationLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
