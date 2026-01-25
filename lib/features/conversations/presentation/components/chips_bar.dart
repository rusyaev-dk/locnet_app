import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_creator/presentation/modals/conversation_creator_modal_card.dart';
import 'package:locnet_app/features/conversations/subfeatures/unified_search/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ChipsBar extends StatelessWidget {
  const ChipsBar({required this.isCompact, super.key});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final double horizontalPadding = isCompact ? 2 : 8;
    final BorderRadius borderRadius = BorderRadius.circular(isCompact ? 10 : 9);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            SizedBox(width: horizontalPadding),
            ChipButton(
              icon: Icons.add,
              label: isCompact ? null : l10n.create,
              backgroundColor: colorScheme.surfaceBright,
              borderRadius: borderRadius,
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  transitionBuilder: slideFadeDialogTransition,
                  pageBuilder: (_, _, _) {
                    return const ConversationCreatorModalWrapper(
                      child: ConversationCreatorModalCard(),
                    );
                  },
                );
              },
            ),
            SizedBox(width: horizontalPadding),
            ChipButton(
              icon: Icons.search,
              label: isCompact ? null : l10n.search,
              backgroundColor: colorScheme.surfaceBright,
              borderRadius: borderRadius,
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  transitionBuilder: slideFadeDialogTransition,
                  pageBuilder: (_, _, _) {
                    return const UnifiedSearchModalCardWrapper(
                      child: UnifiedSearchModalCard(),
                    );
                  },
                );
              },
            ),
            SizedBox(width: horizontalPadding),
          ],
        ),
      ),
    );
  }
}
