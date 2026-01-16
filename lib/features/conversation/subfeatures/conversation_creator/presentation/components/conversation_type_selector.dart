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

    const List<ConversationType> types = [
      ConversationType.group,
      ConversationType.channel,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.conversationType,
          style: textScheme.label.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: types.map((ConversationType type) {
            final bool isSelected = type == selectedConversationType;

            return ChoiceChip(
              backgroundColor: colorScheme.surface,
              label: Text(
                _resolveLocalizedTypeLabel(l10n, type),
                style: textScheme.label.copyWith(
                  color: isSelected
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              selectedColor: colorScheme.surfaceBright,
              selected: isSelected,
              onSelected: (bool selected) {
                if (!selected) {
                  return;
                }
                bloc.add(UpdateConversationTypeEvent(conversationType: type));
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  String _resolveLocalizedTypeLabel(S l10n, ConversationType type) {
    switch (type) {
      case ConversationType.private:
        return l10n.conversationTypePrivate;
      case ConversationType.group:
        return l10n.conversationTypeGroup;
      case ConversationType.channel:
        return l10n.conversationTypeChannel;
    }
  }
}
