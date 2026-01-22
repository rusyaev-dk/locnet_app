import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_creator/presentation/presentation.dart';
import 'package:locnet_app/gen/l10n/l10n.dart';

class ConversationTypeSelector extends StatelessWidget {
  const ConversationTypeSelector({
    required this.selectedConversationType,
    super.key,
  });

  final ConversationType selectedConversationType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;

    final ConversationCreatorBloc bloc = context
        .read<ConversationCreatorBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.conversationType,
          style: textScheme.label.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        _ConversationTypeSegmentedCard(
          selectedConversationType: selectedConversationType,
          onTypeSelected: (ConversationType type) {
            bloc.add(UpdateConversationTypeEvent(conversationType: type));
          },
        ),
        const SizedBox(height: 8),
        Text(
          _resolveHintText(l10n, selectedConversationType),
          style: textScheme.label.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 13,
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

class _ConversationTypeSegmentedCard extends StatelessWidget {
  const _ConversationTypeSegmentedCard({
    required this.selectedConversationType,
    required this.onTypeSelected,
  });

  final ConversationType selectedConversationType;
  final ValueChanged<ConversationType> onTypeSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _ConversationTypeSegmentItem(
              title: l10n.conversationTypeGroup,
              icon: Icons.group_outlined,
              isSelected: selectedConversationType == ConversationType.group,
              onPressed: () => onTypeSelected(ConversationType.group),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _ConversationTypeSegmentItem(
              title: l10n.conversationTypeChannel,
              icon: Icons.campaign_outlined,
              isSelected: selectedConversationType == ConversationType.channel,
              onPressed: () => onTypeSelected(ConversationType.channel),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTypeSegmentItem extends StatelessWidget {
  const _ConversationTypeSegmentItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Color backgroundColor = isSelected
        ? colorScheme.surfaceBright
        : Colors.transparent;

    final Color foregroundColor = isSelected
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 44,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: foregroundColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: textScheme.label.copyWith(
                  color: foregroundColor,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
