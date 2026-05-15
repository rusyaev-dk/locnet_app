import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/auth/presentation/presentation.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';
import 'package:locnet_app/features/conversations_list/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ForwardTargetPickerModalWrapper extends StatelessWidget {
  const ForwardTargetPickerModalWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ConversationsListInteractor>(
      create: (context) => ConversationsListInteractor(
        conversationsListRepo: context
            .read<IAppEnvPreset>()
            .createConversationsListRepo(),
      ),
      child: BlocProvider<AllConversationsListBloc>(
        create: (context) => AllConversationsListBloc(
          conversationsListInteractor: context
              .read<ConversationsListInteractor>(),
          userInteractor: context.read<UserInteractor>(),
          logger: context.read<ILogger>(),
        )..add(const AllConversationsListLoadEvent()),
        child: child,
      ),
    );
  }
}

class ForwardTargetPickerModalCard extends StatefulWidget {
  const ForwardTargetPickerModalCard({
    required this.onTargetSelected,
    super.key,
  });

  final ValueChanged<ConversationTile> onTargetSelected;

  @override
  State<ForwardTargetPickerModalCard> createState() =>
      _ForwardTargetPickerModalCardState();
}

class _ForwardTargetPickerModalCardState
    extends State<ForwardTargetPickerModalCard> {
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
    _queryController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;

    final String currentUserId = context.select<AuthCubit, String>((
      AuthCubit c,
    ) {
      final AuthState s = c.state;
      return s is AuthAuthenticatedState ? s.user.userId : '';
    });

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).maybePop(),
      },
      child: AppModalCard(
        maxWidth: 440,
        verticalInset: 56,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colorScheme.outline)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.messageContextActionForward,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        height: 1.2,
                      ),
                    ),
                  ),
                  SurfaceIconButton(
                    icon: Icons.close,
                    dimension: 32,
                    iconSize: 14,
                    margin: EdgeInsets.zero,
                    foregroundColor: colorScheme.onSurfaceVariant,
                    tooltip: l10n.close,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      controller: _queryController,
                      textInputAction: TextInputAction.search,
                      style: TextStyle(
                        fontSize: 15,
                        color: colorScheme.onSurface,
                        height: 1.2,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.search,
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
                  if (_queryController.text.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    SurfaceIconButton(
                      variant: SurfaceIconVariant.ghost,
                      icon: Icons.close,
                      onPressed: _queryController.clear,
                      dimension: 28,
                      iconSize: 13,
                      margin: EdgeInsets.zero,
                      tooltip: l10n.clear,
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child:
                  BlocBuilder<
                    AllConversationsListBloc,
                    AllConversationsListState
                  >(
                    builder: (context, state) {
                      if (state is AllConversationsListLoadingState) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      }

                      if (state is AllConversationsListFailureState) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: InfoWidget(
                            icon: Icons.error_outline,
                            text: AppExceptionsTranslator.translate(
                              context,
                              state.failure,
                            ),
                            useErrorStyle: true,
                          ),
                        );
                      }

                      if (state is! AllConversationsListLoadedState) {
                        return const SizedBox.shrink();
                      }

                      final String query = _queryController.text
                          .trim()
                          .toLowerCase();

                      final List<ConversationTile> items = state
                          .conversationTiles
                          .where((tile) {
                            if (query.isEmpty) return true;
                            final bool inTitle = tile.title
                                .toLowerCase()
                                .contains(query);
                            final bool inDescription = (tile.description ?? '')
                                .toLowerCase()
                                .contains(query);
                            final bool inLastMessage =
                                (tile.lastMessageText ?? '')
                                    .toLowerCase()
                                    .contains(query);
                            return inTitle || inDescription || inLastMessage;
                          })
                          .toList();

                      if (items.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 32,
                              horizontal: 24,
                            ),
                            child: Text(
                              l10n.nothingFound,
                              style: textScheme.caption.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                        itemCount: items.length,
                        separatorBuilder: (_, _) =>
                            Divider(color: colorScheme.outlineVariant),
                        itemBuilder: (context, index) {
                          final ConversationTile tile = items[index];
                          return ConversationListTile(
                            conversationTile: tile,
                            isCompact: false,
                            currentUserId: currentUserId,
                            onTap: () => widget.onTargetSelected(tile),
                          );
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
