// emoji_selector_overlay.dart
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/message/subfeatures/emoji_selector/presentation/presentation.dart';

class EmojiSelectorOverlay extends StatelessWidget {
  const EmojiSelectorOverlay({
    required this.position,
    required this.textController,
    required this.onDismiss,
    super.key,
  });

  final RelativeRect position;
  final TextEditingController textController;
  final VoidCallback onDismiss;

  static const double _panelWidth = 380;
  static const double _screenPadding = 8;
  static const double _panelMaxHeightFactor = 0.62;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double panelMaxHeight =
            constraints.maxHeight * _panelMaxHeightFactor;

        final double maxLeft = math.max(
          _screenPadding,
          constraints.maxWidth - _panelWidth - _screenPadding,
        );

        final double maxTop = math.max(
          _screenPadding,
          constraints.maxHeight - panelMaxHeight - _screenPadding,
        );

        final double left = position.left.clamp(_screenPadding, maxLeft);
        final double top = position.top.clamp(_screenPadding, maxTop);

        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onDismiss,
                onSecondaryTap: onDismiss,
              ),
            ),
            Positioned(
              left: left,
              top: top,
              width: _panelWidth,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: panelMaxHeight),
                child: _EmojiSelectorPanel(
                  textController: textController,
                  onDismiss: onDismiss,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmojiSelectorPanel extends StatefulWidget {
  const _EmojiSelectorPanel({
    required this.textController,
    required this.onDismiss,
  });

  final TextEditingController textController;
  final VoidCallback onDismiss;

  @override
  State<_EmojiSelectorPanel> createState() => _EmojiSelectorPanelState();
}

class _EmojiSelectorPanelState extends State<_EmojiSelectorPanel> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final Map<EmojiCategoryType, GlobalKey> _sectionKeys =
      <EmojiCategoryType, GlobalKey>{};

  String _query = '';
  final List<String> _recent = <String>[];
  static const int _recentLimit = 36;

  @override
  void initState() {
    super.initState();

    for (final EmojiCategory category in emojiCategories) {
      _sectionKeys[category.type] = GlobalKey();
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   if (!mounted) {
    //     return;
    //   }
    //   await warmUpEmojiRasterization();
    // });

    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    final String newQuery = _searchController.text.trim();
    if (newQuery == _query) {
      return;
    }
    setState(() => _query = newQuery);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(110)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            children: <Widget>[
              EmojiSelectorHeader(
                controller: _searchController,
                onClose: widget.onDismiss,
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              Expanded(
                child: RepaintBoundary(
                  child: _EmojiCategoryScroll(
                    scrollController: _scrollController,
                    sectionKeys: _sectionKeys,
                    query: _query,
                    recent: _recent,
                    onEmojiTap: _handleEmojiTap,
                  ),
                ),
              ),
              EmojiSelectorBottomBar(onCategoryTap: _scrollToCategory),
            ],
          ),
        ),
      ),
    );
  }

  void _handleEmojiTap(String emoji) {
    _insertEmoji(emoji);
    _pushRecent(emoji);
  }

  void _pushRecent(String emoji) {
    setState(() {
      _recent
        ..remove(emoji)
        ..insert(0, emoji);
      if (_recent.length > _recentLimit) {
        _recent.removeRange(_recentLimit, _recent.length);
      }
    });
  }

  void _scrollToCategory(EmojiCategoryType type) {
    if (_query.isNotEmpty) {
      _searchController.clear();
    }

    final GlobalKey? key = _sectionKeys[type];
    final BuildContext? targetContext = key?.currentContext;
    if (targetContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      alignment: 0.02,
    );
  }

  void _insertEmoji(String emoji) {
    final TextEditingValue value = widget.textController.value;
    final String fullText = value.text;
    final TextSelection selection = value.selection;

    final int start = selection.start;
    final int end = selection.end;

    if (start < 0 || end < 0) {
      final String newText = fullText + emoji;
      widget.textController.text = newText;
      widget.textController.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
      return;
    }

    final String newText = fullText.replaceRange(start, end, emoji);
    final int newOffset = start + emoji.length;

    widget.textController.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
      composing: TextRange.empty,
    );
  }
}

class _EmojiCategoryScroll extends StatelessWidget {
  const _EmojiCategoryScroll({
    required this.scrollController,
    required this.sectionKeys,
    required this.query,
    required this.recent,
    required this.onEmojiTap,
  });

  final ScrollController scrollController;
  final Map<EmojiCategoryType, GlobalKey> sectionKeys;
  final String query;
  final List<String> recent;
  final void Function(String emoji) onEmojiTap;

  @override
  Widget build(BuildContext context) {
    final List<EmojiSectionData> sections = _buildSections(
      query: query,
      recent: recent,
      sectionKeys: sectionKeys,
      context: context,
    );

    return CustomScrollView(
      cacheExtent: 250,
      controller: scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: <Widget>[
        for (final EmojiSectionData section in sections) ...<Widget>[
          SliverToBoxAdapter(
            child: _EmojiSectionHeader(key: section.key, title: section.title),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                final String emoji = section.emojis[index];
                return EmojiTile(
                  emoji: emoji,
                  onPressed: () => onEmojiTap(emoji),
                );
              }, childCount: section.emojis.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
      ],
    );
  }

  List<EmojiSectionData> _buildSections({
    required BuildContext context,
    required String query,
    required List<String> recent,
    required Map<EmojiCategoryType, GlobalKey> sectionKeys,
  }) {
    final String q = query.trim();

    if (q.isNotEmpty) {
      final List<String> results = _searchAcrossAll(q);
      return <EmojiSectionData>[
        EmojiSectionData(
          key: null,
          title: emojiSectionTitle(
            context: context,
            type: EmojiSectionType.searchResults,
          ),
          emojis: results,
        ),
      ];
    }

    final List<EmojiSectionData> sections = <EmojiSectionData>[];

    if (recent.isNotEmpty) {
      sections.add(
        EmojiSectionData(
          key: null,
          title: emojiSectionTitle(
            context: context,
            type: EmojiSectionType.recent,
          ),
          emojis: recent,
        ),
      );
    }

    for (final EmojiCategory category in emojiCategories) {
      sections.add(
        EmojiSectionData(
          key: sectionKeys[category.type],
          title: emojiCategoryTitle(context: context, type: category.type),
          emojis: category.emojis,
        ),
      );
    }

    return sections;
  }

  List<String> _searchAcrossAll(String query) {
    final String normalized = query.toLowerCase();

    final Iterable<String> all = emojiCategories.expand(
      (EmojiCategory c) => c.emojis,
    );

    return all.where((String e) => e.contains(normalized)).toList();
  }
}

class _EmojiSectionHeader extends StatelessWidget {
  const _EmojiSectionHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
      child: Text(
        title,
        style: textScheme.headline.copyWith(
          color: colorScheme.onSurfaceVariant.withAlpha(160),
          fontSize: 14.5,
        ),
      ),
    );
  }
}

void warmUpEmojiRasterization() async {
  final List<String> warmUpEmojis = <String>[
    for (final EmojiCategory category in emojiCategories)
      ...category.emojis.take(60),
  ];

  const TextStyle style = TextStyle(fontSize: 24);
  const int batchSize = 80;

  for (
    int startIndex = 0;
    startIndex < warmUpEmojis.length;
    startIndex += batchSize
  ) {
    final int endIndex = math.min(startIndex + batchSize, warmUpEmojis.length);
    final String text = warmUpEmojis.sublist(startIndex, endIndex).join();

    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 10000);

    final PictureRecorder recorder = PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    painter.paint(canvas, Offset.zero);
    recorder.endRecording();
  }
}

String emojiCategoryTitle({
  required BuildContext context,
  required EmojiCategoryType type,
}) {
  final l10n = context.l10n;

  switch (type) {
    case EmojiCategoryType.smileysAndPeople:
      return l10n.emojiCategorySmileysAndPeople;
    case EmojiCategoryType.nature:
      return l10n.emojiCategoryNature;
    case EmojiCategoryType.foodAndDrink:
      return l10n.emojiCategoryFoodAndDrink;
    case EmojiCategoryType.activities:
      return l10n.emojiCategoryActivities;
    case EmojiCategoryType.travelAndPlaces:
      return l10n.emojiCategoryTravelAndPlaces;
    case EmojiCategoryType.objects:
      return l10n.emojiCategoryObjects;
    case EmojiCategoryType.symbols:
      return l10n.emojiCategorySymbols;
    case EmojiCategoryType.flags:
      return l10n.emojiCategoryFlags;
  }
}

String emojiSectionTitle({
  required BuildContext context,
  required EmojiSectionType type,
}) {
  final l10n = context.l10n;

  switch (type) {
    case EmojiSectionType.recent:
      return l10n.emojiCategoryRecent;
    case EmojiSectionType.searchResults:
      return l10n.emojiSearchResults;
  }
}

enum EmojiSectionType { recent, searchResults }
