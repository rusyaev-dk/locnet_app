import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ChipsBar extends StatelessWidget {
  const ChipsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              const SizedBox(width: 8),
              ChipButton(
                icon: Icons.add,
                label: l10n.create,
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (_, _, _) {
                      return const ConversationCreatorModalWrapper(
                        child: ConversationCreatorModalCard(),
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
              ChipButton(
                icon: Icons.search,
                label: l10n.search,
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              ChipButton(label: 'Mock', onPressed: () {}),
              const SizedBox(width: 8),
              ChipButton(label: 'Mock', onPressed: () {}),
              const SizedBox(width: 8),
              ChipButton(label: 'Mock', onPressed: () {}),
              const SizedBox(width: 8),
              ChipButton(label: 'Mock', onPressed: () {}),
              const SizedBox(width: 8),
              ChipButton(label: 'Mock', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
