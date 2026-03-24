import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';

class ConversationSharedMediaSheet extends StatelessWidget {
  const ConversationSharedMediaSheet({
    required this.conversationId,
    required this.conversationType,
    super.key,
  });

  final String conversationId;
  final ConversationType conversationType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              child: Row(
                children: [
                  Text(
                    'Media, files and links',
                    style: textScheme.headline.copyWith(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    splashRadius: 18,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TabBar(
              isScrollable: true,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              tabs: const [
                Tab(text: 'Media'),
                Tab(text: 'Files'),
                Tab(text: 'Links'),
              ],
            ),
            const SizedBox(height: 8),
            const Expanded(
              child: TabBarView(
                children: [
                  _PlaceholderList(
                    icon: Icons.photo_library_outlined,
                    label: 'No media yet',
                  ),
                  _PlaceholderList(
                    icon: Icons.insert_drive_file_outlined,
                    label: 'No files yet',
                  ),
                  _PlaceholderList(
                    icon: Icons.link_outlined,
                    label: 'No links yet',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderList extends StatelessWidget {
  const _PlaceholderList({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 8),
          Text(
            label,
            style: textScheme.caption.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
