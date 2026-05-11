import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final l10n = context.l10n;
    final hasQuery = _query.isNotEmpty;
    final List<_SearchResultItem> results = _buildResults(context);
    final int totalResults = results.length;
    final int activeResultIndex = totalResults == 0
        ? 0
        : _currentResult.clamp(0, totalResults - 1);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).maybePop(),
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Search bar (aligned with [UnifiedSearchModalCard]) ─────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colorScheme.outline)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: colorScheme.onSurface,
                      height: 1.2,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.conversationSearchMessagesHint,
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.2,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (_, value, _) {
                    if (value.text.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return SurfaceIconButton(
                      icon: Icons.backspace_outlined,
                      onPressed: _clear,
                      dimension: 28,
                      iconSize: 13,
                      margin: const EdgeInsets.only(right: 6),
                      tooltip: l10n.clear,
                      foregroundColor: colorScheme.onSurfaceVariant,
                    );
                  },
                ),
                SurfaceIconButton(
                  variant: SurfaceIconVariant.ghost,
                  icon: Icons.close,
                  onPressed: () => Navigator.of(context).maybePop(),
                  dimension: 28,
                  iconSize: 18,
                  margin: EdgeInsets.zero,
                  tooltip: l10n.close,
                  foregroundColor: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),

          Expanded(
            child: hasQuery
                ? _ResultsBody(
                    query: _query,
                    activeResultIndex: activeResultIndex,
                    results: results,
                    onResultTap: (item) =>
                        _selectResult(item, closeSheet: true),
                    colorScheme: colorScheme,
                    textScheme: textScheme,
                  )
                : _ConversationSearchEmptyState(colorScheme: colorScheme),
          ),

          if (hasQuery)
            _SearchNavBar(
              current: totalResults == 0 ? 0 : activeResultIndex + 1,
              total: totalResults,
              resultsSummary: l10n.conversationSearchResultsCount(
                totalResults == 0 ? 0 : activeResultIndex + 1,
                totalResults,
              ),
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

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colorScheme.outline)),
            ),
            child: Row(
              children: [
                ModalKeyboardHint(
                  keyLabel: '↵',
                  description: l10n.modalKeyboardHintSelect,
                ),
                const SizedBox(width: 12),
                ModalKeyboardHint(
                  keyLabel: '↑↓',
                  description: l10n.modalKeyboardHintNavigate,
                ),
              ],
            ),
          ),
        ],
      ),
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
          : context.l10n.you;
      results.add(
        _SearchResultItem(
          messageId: message.id,
          sender: sender.isEmpty ? context.l10n.unknownValue : sender,
          snippet: message.text,
          dateLabel: _buildDateLabel(context, message.createdAt),
        ),
      );
    }
    return results;
  }

  String _buildDateLabel(BuildContext context, DateTime dateTime) {
    final l10n = context.l10n;
    final DateTime local = dateTime.toLocal();
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime date = DateTime(local.year, local.month, local.day);
    final int daysAgo = today.difference(date).inDays;
    if (daysAgo <= 0) {
      return l10n.conversationSearchDateToday;
    }
    if (daysAgo == 1) {
      return l10n.conversationSearchDateYesterday;
    }
    return l10n.conversationSearchDateDaysAgo(daysAgo);
  }
}

// ── Empty state (no query) ───────────────────────────────────────────────────

class _ConversationSearchEmptyState extends StatelessWidget {
  const _ConversationSearchEmptyState({required this.colorScheme});

  final AppColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              size: 36,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.conversationSearchEmptyTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.conversationSearchEmptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
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
          context.l10n.conversationSearchNoMatches,
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
    final radii = context.radii;

    return Material(
      color: isActive ? colorScheme.primary.withAlpha(18) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radii.defaultRadiusValue,
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
    required this.resultsSummary,
    required this.onPrev,
    required this.onNext,
    required this.colorScheme,
    required this.textScheme,
  });

  final int current;
  final int total;
  final String resultsSummary;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final AppColorScheme colorScheme;
  final AppTextScheme textScheme;

  @override
  Widget build(BuildContext context) {
    final bool hasResults = total > 0;
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outline)),
      ),
      child: SizedBox(
        height: 42,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Text(
                resultsSummary,
                style: textScheme.caption.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              SurfaceIconButton(
                variant: SurfaceIconVariant.ghost,
                icon: Icons.keyboard_arrow_up_rounded,
                iconSize: 22,
                margin: EdgeInsets.zero,
                foregroundColor: current > 1
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant.withAlpha(80),
                onPressed: hasResults ? onPrev : () {},
              ),
              const SizedBox(width: 2),
              SurfaceIconButton(
                variant: SurfaceIconVariant.ghost,
                icon: Icons.keyboard_arrow_down_rounded,
                iconSize: 22,
                margin: EdgeInsets.zero,
                foregroundColor: current < total
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant.withAlpha(80),
                onPressed: hasResults ? onNext : () {},
              ),
            ],
          ),
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
