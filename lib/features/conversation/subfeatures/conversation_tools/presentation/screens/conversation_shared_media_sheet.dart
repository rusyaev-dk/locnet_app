import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/features/message/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/media_viewer/media_viewer.dart';
import 'package:locnet_app/uikit/uikit.dart';

// ── Tab definitions ───────────────────────────────────────────────────────────

enum _MediaTab { media, files, links }

String _conversationMediaTabLabel(_MediaTab tab, BuildContext context) {
  final l10n = context.l10n;
  return switch (tab) {
    _MediaTab.media => l10n.conversationSharedMediaTabPhotos,
    _MediaTab.files => l10n.conversationSharedMediaTabFiles,
    _MediaTab.links => l10n.conversationSharedMediaTabLinks,
  };
}

// ── Main widget ───────────────────────────────────────────────────────────────

class ConversationSharedMediaSheet extends StatefulWidget {
  const ConversationSharedMediaSheet({
    required this.conversationId,
    required this.conversationType,
    this.companionName,
    this.mediaInteractor,
    super.key,
  });

  final String conversationId;
  final ConversationType conversationType;
  final String? companionName;
  final MediaInteractor? mediaInteractor;

  @override
  State<ConversationSharedMediaSheet> createState() =>
      _ConversationSharedMediaSheetState();
}

class _ConversationSharedMediaSheetState
    extends State<ConversationSharedMediaSheet> {
  _MediaTab _activeTab = _MediaTab.media;
  final Map<String, Future<MediaDownloadInfo>> _downloadInfoCache =
      <String, Future<MediaDownloadInfo>>{};

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final l10n = context.l10n;
    final String? companion = widget.companionName;

    final Map<_MediaTab, int> tabCounts = _resolveTabCounts();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header ────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 16, 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.outline, width: 1),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.conversationSharedMediaTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        height: 1.2,
                      ),
                    ),
                    if (companion != null && companion.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        l10n.conversationSharedMediaWithName(companion),
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SurfaceIconButton(
                icon: Icons.close,
                onPressed: () => Navigator.of(context).maybePop(),
                margin: EdgeInsets.zero,
                tooltip: context.l10n.close,
              ),
            ],
          ),
        ),

        // ── Underline tab row ─────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.outline, width: 1),
            ),
          ),
          child: Row(
            children: _MediaTab.values.map((tab) {
              return _UnderlineTab(
                label: _conversationMediaTabLabel(tab, context),
                count: tabCounts[tab] ?? 0,
                isSelected: _activeTab == tab,
                colorScheme: colorScheme,
                onTap: () => setState(() => _activeTab = tab),
              );
            }).toList(),
          ),
        ),

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

  Map<_MediaTab, int> _resolveTabCounts() {
    final List<_SharedMediaItem> media = _resolveSharedMediaItems();
    final int imageVideoCount = media
        .where((i) => i.isImage || i.isVideo)
        .length;
    final int fileCount = media
        .where((i) => !i.isImage && !i.isVideo)
        .length;
    return {
      _MediaTab.media: imageVideoCount,
      _MediaTab.files: fileCount,
      _MediaTab.links: 0,
    };
  }

  Widget _buildTabContent(
    _MediaTab tab,
    AppColorScheme colorScheme,
    AppTextScheme textScheme,
  ) {
    final List<_SharedMediaItem> mediaItems = _resolveSharedMediaItems();
    final List<_SharedMediaItem> fileItems = mediaItems
        .where((_SharedMediaItem item) => !item.isImage && !item.isVideo)
        .toList(growable: false);
    return switch (tab) {
      _MediaTab.media => _MediaGrid(
        key: const ValueKey('media'),
        colorScheme: colorScheme,
        items: mediaItems,
        loadDownloadInfo: _resolveDownloadInfo,
      ),
      _MediaTab.files => _FilesList(
        key: const ValueKey('files'),
        colorScheme: colorScheme,
        textScheme: textScheme,
        sharedItems: fileItems,
      ),
      _MediaTab.links => _LinksList(
        key: const ValueKey('links'),
        colorScheme: colorScheme,
        textScheme: textScheme,
      ),
    };
  }

  List<_SharedMediaItem> _resolveSharedMediaItems() {
    if (widget.conversationType != ConversationType.private) {
      return const <_SharedMediaItem>[];
    }

    final PrivateConversationBloc? bloc = context
        .read<PrivateConversationBloc?>();
    if (bloc == null) {
      return const <_SharedMediaItem>[];
    }

    final PrivateConversationState state = bloc.state;
    if (state is! PrivateConversationLoadedState) {
      return const <_SharedMediaItem>[];
    }

    final List<_SharedMediaItem> items = <_SharedMediaItem>[];
    final Set<String> seenMediaIds = <String>{};
    for (final PrivateMessage message in state.messages) {
      for (final PrivateMessageAttachment attachment in message.attachments) {
        final String mediaId = attachment.fileId;
        if (mediaId.isEmpty || seenMediaIds.contains(mediaId)) {
          continue;
        }
        seenMediaIds.add(mediaId);
        items.add(
          _SharedMediaItem(
            mediaId: mediaId,
            kind: attachment.fileType ?? '',
            conversationId: state.conversation.conversationId,
          ),
        );
      }
    }
    return items;
  }

  Future<MediaDownloadInfo> _resolveDownloadInfo(_SharedMediaItem item) {
    final String cacheKey = '${item.mediaId}::${item.conversationId}';
    return _downloadInfoCache.putIfAbsent(cacheKey, () {
      final MediaInteractor? mediaInteractor = widget.mediaInteractor;
      if (mediaInteractor == null) {
        return Future<MediaDownloadInfo>.error(
          StateError('MediaInteractor not available'),
        );
      }

      return mediaInteractor.getDownloadInfo(
        mediaId: item.mediaId,
        scope: 'private_conversation',
        scopeId: item.conversationId,
      );
    });
  }
}

// ── Underline tab ─────────────────────────────────────────────────────────────

class _UnderlineTab extends StatelessWidget {
  const _UnderlineTab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.colorScheme,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final AppColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                height: 1.2,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withAlpha(30)
                      : colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Media grid ────────────────────────────────────────────────────────────────

// Deterministic icon accent colors for media placeholder icons
const List<Color> _kMediaIconColors = [
  Color(0xFF4B7BEC),
  Color(0xFF26A65B),
  Color(0xFF8B5CF6),
  Color(0xFFE67E22),
  Color(0xFF3498DB),
  Color(0xFFC0392B),
  Color(0xFF1ABC9C),
  Color(0xFFE74C3C),
];

class _MediaGrid extends StatelessWidget {
  const _MediaGrid({
    required this.colorScheme,
    required this.items,
    required this.loadDownloadInfo,
    super.key,
  });

  final AppColorScheme colorScheme;
  final List<_SharedMediaItem> items;
  final Future<MediaDownloadInfo> Function(_SharedMediaItem item)
  loadDownloadInfo;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyTabState(
        icon: Icons.photo_library_outlined,
        label: context.l10n.conversationSharedMediaEmptyMedia,
        colorScheme: colorScheme,
        textScheme: context.textScheme,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final _SharedMediaItem item = items[index];
        final Color accentColor = _kMediaIconColors[index % _kMediaIconColors.length];
        return FutureBuilder<MediaDownloadInfo>(
          future: loadDownloadInfo(item),
          builder:
              (
                BuildContext context,
                AsyncSnapshot<MediaDownloadInfo> snapshot,
              ) {
                return _MediaCard(
                  colorScheme: colorScheme,
                  accentColor: accentColor,
                  mediaId: item.mediaId,
                  snapshot: snapshot,
                  item: item,
                );
              },
        );
      },
    );
  }
}

class _MediaCard extends StatelessWidget {
  const _MediaCard({
    required this.colorScheme,
    required this.accentColor,
    required this.mediaId,
    required this.snapshot,
    required this.item,
  });

  final AppColorScheme colorScheme;
  final Color accentColor;
  final String mediaId;
  final AsyncSnapshot<MediaDownloadInfo> snapshot;
  final _SharedMediaItem item;

  String get _shortName {
    final String id = mediaId;
    if (id.length > 20) return '${id.substring(0, 18)}…';
    return id;
  }

  @override
  Widget build(BuildContext context) {
    final bool loading = snapshot.connectionState != ConnectionState.done;
    final MediaDownloadInfo? info = snapshot.data;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border.all(color: colorScheme.outline, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: info == null
              ? null
              : () {
                  final String type = item.kind.isEmpty
                      ? info.mimeType
                      : item.kind;
                  if (type.startsWith('image')) {
                    showImageGalleryViewerModal(
                      context: context,
                      imageUrls: [info.downloadUrl],
                      initialIndex: 0,
                    );
                  } else if (type.startsWith('video')) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => MessageVideoPlayerScreen(
                          videoUrl: info.downloadUrl,
                        ),
                      ),
                    );
                  }
                },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: loading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: accentColor,
                            ),
                          )
                        : (info != null && _isImageOrVideo(info, item))
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: info.downloadUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorWidget:
                                      (_, _, _) => _MediaIconPlaceholder(
                                        accentColor: accentColor,
                                      ),
                                ),
                              )
                            : _MediaIconPlaceholder(accentColor: accentColor),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _shortName,
                  style: GoogleFonts.dmMono(
                    fontSize: 9,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isImageOrVideo(MediaDownloadInfo info, _SharedMediaItem item) {
    final String type = item.kind.isEmpty ? info.mimeType : item.kind;
    return type.startsWith('image') || type.startsWith('video');
  }
}

class _MediaIconPlaceholder extends StatelessWidget {
  const _MediaIconPlaceholder({required this.accentColor});
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: accentColor.withAlpha(36),
        border: Border.all(color: accentColor.withAlpha(80), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.remove_red_eye_outlined,
        size: 22,
        color: accentColor,
      ),
    );
  }
}

// ── Files list ────────────────────────────────────────────────────────────────

class _FilesList extends StatelessWidget {
  const _FilesList({
    required this.colorScheme,
    required this.textScheme,
    required this.sharedItems,
    super.key,
  });

  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;
  final List<_SharedMediaItem> sharedItems;

  @override
  Widget build(BuildContext context) {
    final radii = context.radii;
    final l10n = context.l10n;

    if (sharedItems.isEmpty) {
      return _EmptyTabState(
        icon: Icons.folder_open_outlined,
        label: l10n.conversationSharedMediaEmptyFiles,
        colorScheme: colorScheme,
        textScheme: textScheme,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        AppTileButtonGroupCard(
          backgroundColor: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(radii.large),
          dividerIndent: 54,
          children: sharedItems
              .map(
                (item) => _FileTile(
                  item: item,
                  colorScheme: colorScheme,
                  textScheme: textScheme,
                  attachmentLabel: l10n.conversationSharedMediaAttachment,
                  sharedLabel: l10n.conversationSharedMediaMarkedAsShared,
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

final class _SharedMediaItem {
  const _SharedMediaItem({
    required this.mediaId,
    required this.kind,
    required this.conversationId,
  });

  final String mediaId;
  final String kind;
  final String conversationId;

  bool get isImage => kind.startsWith('image');
  bool get isVideo => kind.startsWith('video');
}

({IconData icon, Color color}) _fileIconForKind(String kind) {
  final String k = kind.toLowerCase();
  if (k.contains('pdf')) {
    return (
      icon: Icons.picture_as_pdf_outlined,
      color: const Color(0xFFE53935),
    );
  }
  if (k.contains('zip') || k.contains('rar') || k.contains('7z')) {
    return (
      icon: Icons.folder_zip_outlined,
      color: const Color(0xFFFB8C00),
    );
  }
  if (k.contains('sheet') ||
      k.contains('excel') ||
      k.contains('spreadsheet') ||
      k.endsWith('csv')) {
    return (
      icon: Icons.table_chart_outlined,
      color: const Color(0xFF43A047),
    );
  }
  if (k.contains('fig') || k.contains('sketch')) {
    return (
      icon: Icons.auto_awesome_outlined,
      color: const Color(0xFF8B5CF6),
    );
  }
  return (
    icon: Icons.description_outlined,
    color: const Color(0xFF1E88E5),
  );
}

class _FileTile extends StatelessWidget {
  const _FileTile({
    required this.item,
    required this.colorScheme,
    required this.textScheme,
    required this.attachmentLabel,
    required this.sharedLabel,
  });

  final _SharedMediaItem item;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;
  final String attachmentLabel;
  final String sharedLabel;

  @override
  Widget build(BuildContext context) {
    final radii = context.radii;
    final ({IconData icon, Color color}) visuals = _fileIconForKind(item.kind);
    final String title = item.mediaId.isNotEmpty ? item.mediaId : attachmentLabel;
    final String subtitle = item.kind.isNotEmpty ? item.kind : sharedLabel;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {}, // TODO: open / share file
        borderRadius: radii.defaultRadiusValue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: visuals.color.withAlpha(28),
                  borderRadius: radii.defaultRadiusValue,
                ),
                child: Icon(visuals.icon, color: visuals.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: textScheme.subtitle.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
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

// ── Links list ────────────────────────────────────────────────────────────────

class _LinksList extends StatelessWidget {
  const _LinksList({
    required this.colorScheme,
    required this.textScheme,
    super.key,
  });

  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  @override
  Widget build(BuildContext context) {
    return _EmptyTabState(
      icon: Icons.link_off_outlined,
      label: context.l10n.conversationSharedMediaEmptyLinks,
      colorScheme: colorScheme,
      textScheme: textScheme,
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
          Icon(icon, size: 65, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            label,
            style: textScheme.headline.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
