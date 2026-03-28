import 'package:flutter/material.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ConversationSearchSheet extends StatefulWidget {
  const ConversationSearchSheet({
    required this.conversationId,
    required this.conversationType,
    super.key,
  });

  final String conversationId;
  final ConversationType conversationType;

  @override
  State<ConversationSearchSheet> createState() =>
      _ConversationSearchSheetState();
}

class _ConversationSearchSheetState extends State<ConversationSearchSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _query = '';

  static const List<String> _recentSearches = [
    'Project meeting',
    'Invoice Q1',
    'figma link',
  ];

  static const int _mockResultCount = 7;
  int _currentResult = 1;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    final text = _controller.text;
    if (text != _query) {
      setState(() {
        _query = text;
        _currentResult = 1;
      });
    }
  }

  void _clear() {
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _prevResult() {
    if (_currentResult > 1) setState(() => _currentResult--);
  }

  void _nextResult() {
    if (_currentResult < _mockResultCount) setState(() => _currentResult++);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final radii = context.radii;
    final hasQuery = _query.isNotEmpty;

    return Column(
      children: [
        // ── Header: search field + close ──────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: radii.defaultRadiusValue,
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    style: textScheme.body.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      suffixIcon: hasQuery
                          ? GestureDetector(
                              onTap: _clear,
                              child: Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            )
                          : null,
                      hintText: 'Search in conversation',
                      hintStyle: textScheme.body.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 2),
              // Close button — same as ConversationInfoHeroHeader
              RoundedIconButton(
                icon: Icons.close,
                foregroundColor: colorScheme.onSurfaceVariant,
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: 'Close',
              ),
            ],
          ),
        ),

        Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),

        // ── Body ──────────────────────────────────────────────────────
        Expanded(
          child: hasQuery
              ? _ResultsBody(
                  query: _query,
                  currentResult: _currentResult,
                  totalResults: _mockResultCount,
                  colorScheme: colorScheme,
                  textScheme: textScheme,
                )
              : _RecentBody(
                  recentSearches: _recentSearches,
                  colorScheme: colorScheme,
                  textScheme: textScheme,
                  onTap: (term) {
                    _controller.text = term;
                    _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: term.length),
                    );
                  },
                ),
        ),

        // ── Navigation bar ────────────────────────────────────────────
        if (hasQuery) ...[
          Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
          _SearchNavBar(
            current: _currentResult,
            total: _mockResultCount,
            onPrev: _prevResult,
            onNext: _nextResult,
            colorScheme: colorScheme,
            textScheme: textScheme,
          ),
        ],
      ],
    );
  }
}

// ── Recent searches ───────────────────────────────────────────────────────────

class _RecentBody extends StatelessWidget {
  const _RecentBody({
    required this.recentSearches,
    required this.colorScheme,
    required this.textScheme,
    required this.onTap,
  });

  final List<String> recentSearches;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final radii = context.radii;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      children: [
        // Section label — matches CompanionInfoModalCard style
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'RECENT',
            style: textScheme.caption.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              fontSize: 11,
            ),
          ),
        ),
        // Group card — matches AppTileButtonGroupCard style
        AppTileButtonGroupCard(
          backgroundColor: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(radii.large),
          dividerIndent: 44,
          children: recentSearches
              .map(
                (term) => _RecentTile(
                  term: term,
                  colorScheme: colorScheme,
                  textScheme: textScheme,
                  onTap: () => onTap(term),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _RecentTile extends StatelessWidget {
  const _RecentTile({
    required this.term,
    required this.colorScheme,
    required this.textScheme,
    required this.onTap,
  });

  final String term;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radii = context.radii;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radii.defaultRadiusValue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              Icon(
                Icons.history_rounded,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  term,
                  style: textScheme.subtitle.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.north_west_rounded,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Results list ──────────────────────────────────────────────────────────────

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({
    required this.query,
    required this.currentResult,
    required this.totalResults,
    required this.colorScheme,
    required this.textScheme,
  });

  final String query;
  final int currentResult;
  final int totalResults;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  static const _senders = ['Alice', 'Bob', 'You', 'Carol'];
  static const _snippets = [
    'Here is the file you requested for the report.',
    'Let me know when you have a chance to review.',
    'I will send you the updated version shortly.',
    'The meeting has been rescheduled to Thursday.',
    'Can you double-check the numbers in section 3?',
    'Looks great! Ship it.',
    'Thanks, I will get back to you by EOD.',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: totalResults,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 1,
        indent: 56,
        color: colorScheme.outlineVariant,
      ),
      itemBuilder: (context, index) {
        final isActive = index + 1 == currentResult;
        final sender = _senders[index % _senders.length];
        final snippet = _snippets[index % _snippets.length];
        final daysAgo = index * 2;
        final dateLabel = daysAgo == 0
            ? 'Today'
            : daysAgo == 1
                ? 'Yesterday'
                : '$daysAgo days ago';

        return _ResultTile(
          sender: sender,
          snippet: snippet,
          dateLabel: dateLabel,
          isActive: isActive,
          query: query,
          colorScheme: colorScheme,
          textScheme: textScheme,
        );
      },
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.sender,
    required this.snippet,
    required this.dateLabel,
    required this.isActive,
    required this.query,
    required this.colorScheme,
    required this.textScheme,
  });

  final String sender;
  final String snippet;
  final String dateLabel;
  final bool isActive;
  final String query;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isActive
          ? colorScheme.primary.withAlpha(18)
          : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                sender[0],
                style: textScheme.caption.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
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
                        sender,
                        style: textScheme.subtitle.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        dateLabel,
                        style: textScheme.caption.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  _HighlightText(
                    text: snippet,
                    query: query,
                    normalStyle: textScheme.caption.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    highlightStyle: textScheme.caption.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
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

class _HighlightText extends StatelessWidget {
  const _HighlightText({
    required this.text,
    required this.query,
    required this.normalStyle,
    required this.highlightStyle,
    this.maxLines = 1,
  });

  final String text;
  final String query;
  final TextStyle normalStyle;
  final TextStyle highlightStyle;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: normalStyle, maxLines: maxLines,
          overflow: TextOverflow.ellipsis);
    }

    final lower = text.toLowerCase();
    final q = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final idx = lower.indexOf(q, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start), style: normalStyle));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(
            text: text.substring(start, idx), style: normalStyle));
      }
      spans.add(TextSpan(
          text: text.substring(idx, idx + query.length),
          style: highlightStyle));
      start = idx + query.length;
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// ── Navigation bar ────────────────────────────────────────────────────────────

class _SearchNavBar extends StatelessWidget {
  const _SearchNavBar({
    required this.current,
    required this.total,
    required this.onPrev,
    required this.onNext,
    required this.colorScheme,
    required this.textScheme,
  });

  final int current;
  final int total;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Text(
              '$current of $total',
              style: textScheme.caption.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            RoundedIconButton(
              icon: Icons.keyboard_arrow_up_rounded,
              foregroundColor: current > 1
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant.withAlpha(80),
              onPressed: onPrev,
              iconSize: 22,
            ),
            const SizedBox(width: 2),
            RoundedIconButton(
              icon: Icons.keyboard_arrow_down_rounded,
              foregroundColor: current < total
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant.withAlpha(80),
              onPressed: onNext,
              iconSize: 22,
            ),
          ],
        ),
      ),
    );
  }
}
