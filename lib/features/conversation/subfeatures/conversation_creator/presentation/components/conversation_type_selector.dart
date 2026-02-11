import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_creator/presentation/presentation.dart';
import 'package:locnet_app/gen/l10n/l10n.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ConversationTypeSelector extends StatelessWidget {
  const ConversationTypeSelector({
    required this.selectedConversationType,
    super.key,
  });

  final ConversationType selectedConversationType;

  static const List<ConversationType> _segmentTypes = [
    ConversationType.group,
    ConversationType.channel,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;
    final bloc = context.read<ConversationCreatorBloc>();

    final selectedIndex = _segmentTypes.indexOf(selectedConversationType);
    final segments = [
      SegmentedControlSegment(
        title: l10n.conversationTypeGroup,
        icon: Icons.group_outlined,
      ),
      SegmentedControlSegment(
        title: l10n.conversationTypeChannel,
        icon: Icons.campaign_outlined,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.conversationType,
          style: textScheme.label.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        SegmentedControl(
          segments: segments,
          selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
          onSelected: (int index) {
            bloc.add(
              UpdateConversationTypeEvent(
                conversationType: _segmentTypes[index],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: Text(
            _resolveHintText(l10n, selectedConversationType),
            key: ValueKey<ConversationType>(selectedConversationType),
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  String _resolveHintText(S l10n, ConversationType type) {
    switch (type) {
      case ConversationType.private:
        return '';
      case ConversationType.group:
        return l10n.conversationTypeGroupHint;
      case ConversationType.channel:
        return l10n.conversationTypeChannelHint;
    }
  }
}
