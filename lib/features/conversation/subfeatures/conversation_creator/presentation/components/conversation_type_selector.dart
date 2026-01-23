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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.conversationType,
          style: textScheme.label.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        ConversationTypeSegmentedControl(
          selectedConversationType: selectedConversationType,
          onTypeSelected: (ConversationType type) {
            bloc.add(UpdateConversationTypeEvent(conversationType: type));
          },
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: Text(
            _resolveHintText(l10n, selectedConversationType),
            key: ValueKey<ConversationType>(selectedConversationType),
            style: textScheme.label.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  String _resolveHintText(S l10n, ConversationType type) {
    switch (type) {
      case ConversationType.private:
        return '';
      case ConversationType.group:
        return l10n.conversationTypeGroupHint;
      case ConversationType.channel:
        return l10n.conversationTypeChannelHint;
    }
  }
}

class ConversationTypeSegmentedControl extends StatelessWidget {
  const ConversationTypeSegmentedControl({
    required this.selectedConversationType,
    required this.onTypeSelected,
    super.key,
  });

  final ConversationType selectedConversationType;
  final ValueChanged<ConversationType> onTypeSelected;

  static const Duration _moveDuration = Duration(milliseconds: 260);
  static const Curve _moveCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final bool isGroupSelected =
        selectedConversationType == ConversationType.group;
    final Alignment indicatorAlignment = isGroupSelected
        ? Alignment.centerLeft
        : Alignment.centerRight;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double segmentWidth = (constraints.maxWidth - 4) / 2;

        return Container(
          height: 52,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: _moveDuration,
                curve: _moveCurve,
                alignment: indicatorAlignment,
                child: _SegmentIndicator(width: segmentWidth),
              ),
              Row(
                children: [
                  Expanded(
                    child: _SegmentButton(
                      title: l10n.conversationTypeGroup,
                      icon: Icons.group_outlined,
                      isSelected: isGroupSelected,
                      onPressed: () => onTypeSelected(ConversationType.group),
                    ),
                  ),
                  Expanded(
                    child: _SegmentButton(
                      title: l10n.conversationTypeChannel,
                      icon: Icons.campaign_outlined,
                      isSelected: !isGroupSelected,
                      onPressed: () => onTypeSelected(ConversationType.channel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SegmentIndicator extends StatelessWidget {
  const _SegmentIndicator({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.primary.withAlpha(0x14),
        border: Border.all(color: colorScheme.primary.withAlpha(0x3D)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: -6,
            offset: const Offset(0, 4),
            color: colorScheme.primary.withAlpha(0x22),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  static const Duration _styleDuration = Duration(milliseconds: 220);
  static const Curve _styleCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final Color targetForegroundColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Center(
        child: TweenAnimationBuilder<Color?>(
          duration: _styleDuration,
          curve: _styleCurve,
          tween: ColorTween(end: targetForegroundColor),
          builder: (BuildContext context, Color? animatedColor, Widget? child) {
            final Color resolvedColor = animatedColor ?? targetForegroundColor;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: resolvedColor),
                const SizedBox(width: 8),
                AnimatedDefaultTextStyle(
                  duration: _styleDuration,
                  curve: _styleCurve,
                  style: textScheme.label.copyWith(
                    color: resolvedColor,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  child: Text(title),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
