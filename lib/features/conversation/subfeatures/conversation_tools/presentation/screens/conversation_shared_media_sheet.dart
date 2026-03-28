import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/uikit/uikit.dart';

// ── Tab definitions ───────────────────────────────────────────────────────────

enum _MediaTab { media, files, links, voice, music }

extension _MediaTabExt on _MediaTab {
  String get label => switch (this) {
        _MediaTab.media => 'Media',
        _MediaTab.files => 'Files',
        _MediaTab.links => 'Links',
        _MediaTab.voice => 'Voice',
        _MediaTab.music => 'Music',
      };

  IconData get icon => switch (this) {
        _MediaTab.media => Icons.photo_library_outlined,
        _MediaTab.files => Icons.insert_drive_file_outlined,
        _MediaTab.links => Icons.link_rounded,
        _MediaTab.voice => Icons.mic_none_rounded,
        _MediaTab.music => Icons.music_note_outlined,
      };
}

// ── Main widget ───────────────────────────────────────────────────────────────

class ConversationSharedMediaSheet extends StatefulWidget {
  const ConversationSharedMediaSheet({
    required this.conversationId,
    required this.conversationType,
    super.key,
  });

  final String conversationId;
  final ConversationType conversationType;

  @override
  State<ConversationSharedMediaSheet> createState() =>
      _ConversationSharedMediaSheetState();
}

class _ConversationSharedMediaSheetState
    extends State<ConversationSharedMediaSheet> {
  _MediaTab _activeTab = _MediaTab.media;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header — matches ConversationInfoHeroHeader layout ────────
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Shared Media',
                  style: textScheme.headline.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: RoundedIconButton(
                icon: Icons.close,
                foregroundColor: colorScheme.onSurfaceVariant,
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: 'Close',
              ),
            ),
          ],
        ),

        // ── Scrollable tab row ────────────────────────────────────────
        SizedBox(
          height: 32,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            children: _MediaTab.values.map((tab) {
              return _TabChip(
                label: tab.label,
                isSelected: _activeTab == tab,
                colorScheme: colorScheme,
                textScheme: textScheme,
                onTap: () => setState(() => _activeTab = tab),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 8),
        Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),

        // ── Content ───────────────────────────────────────────────────
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: _buildTabContent(_activeTab, colorScheme, textScheme),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(
    _MediaTab tab,
    AppColorScheme colorScheme,
    AppTextScheme textScheme,
  ) {
    return switch (tab) {
      _MediaTab.media => _MediaGrid(
          key: const ValueKey('media'),
          colorScheme: colorScheme,
        ),
      _MediaTab.files => _FilesList(
          key: const ValueKey('files'),
          colorScheme: colorScheme,
          textScheme: textScheme,
        ),
      _MediaTab.links => _LinksList(
          key: const ValueKey('links'),
          colorScheme: colorScheme,
          textScheme: textScheme,
        ),
      _MediaTab.voice => _EmptyTabState(
          key: const ValueKey('voice'),
          icon: _MediaTab.voice.icon,
          label: 'No voice messages',
          colorScheme: colorScheme,
          textScheme: textScheme,
        ),
      _MediaTab.music => _EmptyTabState(
          key: const ValueKey('music'),
          icon: _MediaTab.music.icon,
          label: 'No music files',
          colorScheme: colorScheme,
          textScheme: textScheme,
        ),
    };
  }
}

// ── Tab chip — uses radii.defaultRadiusValue (6 px) ──────────────────────────

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.colorScheme,
    required this.textScheme,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;
  final VoidCallback onTap;

  static const _duration = Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    final radii = context.radii;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: _duration,
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHigh,
          borderRadius: radii.defaultRadiusValue,
        ),
        child: Text(
          label,
          style: textScheme.caption.copyWith(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ── Media grid ────────────────────────────────────────────────────────────────

class _MediaGrid extends StatelessWidget {
  const _MediaGrid({required this.colorScheme, super.key});

  final AppColorScheme colorScheme;

  static const int _itemCount = 18;

  @override
  Widget build(BuildContext context) {
    final radii = context.radii;

    return GridView.builder(
      padding: const EdgeInsets.all(3),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
      itemCount: _itemCount,
      itemBuilder: (context, index) {
        final shade = index.isEven
            ? colorScheme.surfaceContainer
            : colorScheme.surfaceContainerHigh;

        return ClipRRect(
          borderRadius: radii.smallRadius,
          child: Container(
            color: shade,
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: 26,
                color: colorScheme.onSurfaceVariant.withAlpha(70),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Files list ────────────────────────────────────────────────────────────────

enum _FileKind { pdf, zip, doc, fig, xls }

class _FileItem {
  const _FileItem(this.name, this.size, this.date, this.kind);
  final String name;
  final String size;
  final String date;
  final _FileKind kind;
}

class _FilesList extends StatelessWidget {
  const _FilesList({
    required this.colorScheme,
    required this.textScheme,
    super.key,
  });

  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  static const _files = [
    _FileItem('Project_Brief.pdf', '2.4 MB', 'Mar 22', _FileKind.pdf),
    _FileItem('Design_Assets.zip', '18.1 MB', 'Mar 19', _FileKind.zip),
    _FileItem('Meeting_Notes.docx', '340 KB', 'Mar 15', _FileKind.doc),
    _FileItem('Prototype_v3.fig', '6.7 MB', 'Mar 10', _FileKind.fig),
    _FileItem('Budget_Q1.xlsx', '512 KB', 'Feb 28', _FileKind.xls),
  ];

  @override
  Widget build(BuildContext context) {
    final radii = context.radii;

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        AppTileButtonGroupCard(
          backgroundColor: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(radii.large),
          dividerIndent: 54,
          children: _files
              .map(
                (f) => _FileTile(
                  item: f,
                  colorScheme: colorScheme,
                  textScheme: textScheme,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _FileTile extends StatelessWidget {
  const _FileTile({
    required this.item,
    required this.colorScheme,
    required this.textScheme,
  });

  final _FileItem item;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  Color _iconColor() => switch (item.kind) {
        _FileKind.pdf => const Color(0xFFE53935),
        _FileKind.zip => const Color(0xFFFB8C00),
        _FileKind.doc => const Color(0xFF1E88E5),
        _FileKind.fig => const Color(0xFF8B5CF6),
        _FileKind.xls => const Color(0xFF43A047),
      };

  IconData _icon() => switch (item.kind) {
        _FileKind.pdf => Icons.picture_as_pdf_outlined,
        _FileKind.zip => Icons.folder_zip_outlined,
        _FileKind.doc => Icons.description_outlined,
        _FileKind.fig => Icons.auto_awesome_outlined,
        _FileKind.xls => Icons.table_chart_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final radii = context.radii;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {}, // TODO: open / share file
        borderRadius: radii.defaultRadiusValue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              // Colored file icon — uses app radius tokens
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _iconColor().withAlpha(28),
                  borderRadius: radii.defaultRadiusValue,
                ),
                child: Icon(_icon(), color: _iconColor(), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name,
                      style: textScheme.subtitle.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.size} · ${item.date}',
                      style: textScheme.caption.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Links list ────────────────────────────────────────────────────────────────

class _LinkItem {
  const _LinkItem(this.domain, this.title, this.url, this.date);
  final String domain;
  final String title;
  final String url;
  final String date;
}

class _LinksList extends StatelessWidget {
  const _LinksList({
    required this.colorScheme,
    required this.textScheme,
    super.key,
  });

  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  static const _links = [
    _LinkItem(
      'figma.com',
      'LocNet App – Design System',
      'https://figma.com/file/...',
      'Mar 24',
    ),
    _LinkItem(
      'github.com',
      'locnet-app / mobile · Pull Request #47',
      'https://github.com/locnet-app/...',
      'Mar 21',
    ),
    _LinkItem(
      'notion.so',
      'Q1 Roadmap & OKRs',
      'https://notion.so/locnet/...',
      'Mar 18',
    ),
    _LinkItem(
      'youtube.com',
      'Flutter State Management – Full Course',
      'https://youtube.com/watch?...',
      'Mar 12',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final radii = context.radii;

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        AppTileButtonGroupCard(
          backgroundColor: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(radii.large),
          dividerIndent: 54,
          children: _links
              .map(
                (l) => _LinkTile(
                  item: l,
                  colorScheme: colorScheme,
                  textScheme: textScheme,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.item,
    required this.colorScheme,
    required this.textScheme,
  });

  final _LinkItem item;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  @override
  Widget build(BuildContext context) {
    final radii = context.radii;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {}, // TODO: launch URL
        borderRadius: radii.defaultRadiusValue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Domain initial badge — matches AppTileButton icon slot width
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: radii.defaultRadiusValue,
                ),
                child: Center(
                  child: Text(
                    item.domain[0].toUpperCase(),
                    style: textScheme.subtitle.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.domain,
                          style: textScheme.caption.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.date,
                          style: textScheme.caption.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.title,
                      style: textScheme.subtitle.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.url,
                      style: textScheme.caption.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state — mirrors InfoWidget proportions ──────────────────────────────

class _EmptyTabState extends StatelessWidget {
  const _EmptyTabState({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.textScheme,
    super.key,
  });

  final IconData icon;
  final String label;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 65,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: textScheme.headline.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
