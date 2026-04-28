import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/private.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ConversationSearchSheet extends StatefulWidget {
  const ConversationSearchSheet({
    required this.conversationId,
    required this.conversationType,
    this.onMessageSelected,
    super.key,
  });

  final String conversationId;
  final ConversationType conversationType;
  final ValueChanged<String>? onMessageSelected;

  @override
  State<ConversationSearchSheet> createState() =>
      _ConversationSearchSheetState();
}

class _ConversationSearchSheetState extends State<ConversationSearchSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _query = '';

  int _currentResult = 0;

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
        _currentResult = 0;
      });
    }
  }

  void _clear() {
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _prevResult(int totalResults) {
    if (totalResults <= 0) {
      return;
    }
    setState(() {
      _currentResult = (_currentResult - 1 + totalResults) % totalResults;
    });
  }

  void _nextResult(int totalResults) {
    if (totalResults <= 0) {
      return;
    }
    setState(() {
      _currentResult = (_currentResult + 1) % totalResults;
    });
  }

  void _selectResult(_SearchResultItem result, {required bool closeSheet}) {
    widget.onMessageSelected?.call(result.messageId);
    if (closeSheet) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final radii = context.radii;
    final hasQuery = _query.isNotEmpty;
    final List<_SearchResultItem> results = _buildResults(context);
    final int totalResults = results.length;
    final int activeResultIndex = totalResults == 0
        ? 0
        : _currentResult.clamp(0, totalResults - 1);

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
                  activeResultIndex: activeResultIndex,
                  results: results,
                  onResultTap: (item) => _selectResult(item, closeSheet: true),
                  colorScheme: colorScheme,
                  textScheme: textScheme,
                )
              : Center(
                  child: Text(
                    'Type to search messages',
                    style: textScheme.caption.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
        ),

        // ── Navigation bar ────────────────────────────────────────────
        if (hasQuery) ...[
          Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
          _SearchNavBar(
            current: totalResults == 0 ? 0 : activeResultIndex + 1,
            total: totalResults,
            onPrev: () {
              _prevResult(totalResults);
              if (totalResults > 0) {
                _selectResult(results[_currentResult], closeSheet: false);
              }
            },
            onNext: () {
              _nextResult(totalResults);
              if (totalResults > 0) {
                _selectResult(results[_currentResult], closeSheet: false);
              }
            },
            colorScheme: colorScheme,
            textScheme: textScheme,
          ),
        ],
      ],
    );
  }

  List<_SearchResultItem> _buildResults(BuildContext context) {
    if (widget.conversationType != ConversationType.private) {
      return const <_SearchResultItem>[];
    }
    if (_query.trim().isEmpty) {
      return const <_SearchResultItem>[];
    }

    final PrivateConversationState state = context
        .read<PrivateConversationBloc>()
        .state;
    if (state is! PrivateConversationLoadedState) {
      return const <_SearchResultItem>[];
    }

    final String companionName =
        '${state.companion.firstName} ${state.companion.lastName}'.trim();
    final String normalizedQuery = _query.trim().toLowerCase();
    final List<_SearchResultItem> results = <_SearchResultItem>[];

    for (final PrivateMessage message in state.messages) {
      final String normalizedText = message.text.toLowerCase();
      if (!normalizedText.contains(normalizedQuery)) {
        continue;
      }
      final String sender = message.senderId == state.companionId
          ? companionName
          : 'You';
      results.add(
        _SearchResultItem(
          messageId: message.id,
          sender: sender.isEmpty ? 'Unknown' : sender,
          snippet: message.text,
          dateLabel: _buildDateLabel(message.createdAt),
        ),
      );
    }
    return results;
  }

  String _buildDateLabel(DateTime dateTime) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final int daysAgo = today.difference(date).inDays;
    if (daysAgo <= 0) {
      return 'Today';
    }
    if (daysAgo == 1) {
      return 'Yesterday';
    }
    return '$daysAgo days ago';
  }
}

// ── Results list ──────────────────────────────────────────────────────────────

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({
    required this.query,
    required this.activeResultIndex,
    required this.results,
    required this.onResultTap,
    required this.colorScheme,
    required this.textScheme,
  });

  final String query;
  final int activeResultIndex;
  final List<_SearchResultItem> results;
  final ValueChanged<_SearchResultItem> onResultTap;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Text(
          'No matches found',
          style: textScheme.caption.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: results.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 1,
        indent: 56,
        color: colorScheme.outlineVariant,
      ),
      itemBuilder: (context, index) {
        final isActive = index == activeResultIndex;
        final _SearchResultItem result = results[index];

        return _ResultTile(
          sender: result.sender,
          snippet: result.snippet,
          dateLabel: result.dateLabel,
          isActive: isActive,
          query: query,
          onTap: () => onResultTap(result),
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
    required this.onTap,
    required this.colorScheme,
    required this.textScheme,
  });

  final String sender;
  final String snippet;
  final String dateLabel;
  final bool isActive;
  final String query;
  final VoidCallback onTap;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? colorScheme.primary.withAlpha(18) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
      return Text(
        text,
        style: normalStyle,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
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
        spans.add(
          TextSpan(text: text.substring(start, idx), style: normalStyle),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(idx, idx + query.length),
          style: highlightStyle,
        ),
      );
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
    final bool hasResults = total > 0;
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
              onPressed: hasResults ? onPrev : () {},
              iconSize: 22,
            ),
            const SizedBox(width: 2),
            RoundedIconButton(
              icon: Icons.keyboard_arrow_down_rounded,
              foregroundColor: current < total
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant.withAlpha(80),
              onPressed: hasResults ? onNext : () {},
              iconSize: 22,
            ),
          ],
        ),
      ),
    );
  }
}

final class _SearchResultItem {
  const _SearchResultItem({
    required this.messageId,
    required this.sender,
    required this.snippet,
    required this.dateLabel,
  });

  final String messageId;
  final String sender;
  final String snippet;
  final String dateLabel;
}
