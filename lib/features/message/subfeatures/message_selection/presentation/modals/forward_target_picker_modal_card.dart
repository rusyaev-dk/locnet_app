import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversations_list/domain/domain.dart';
import 'package:locnet_app/features/conversations_list/presentation/blocs/all_conversations_list_bloc/all_conversations_list_bloc.dart';
import 'package:locnet_app/uikit/uikit.dart';

/// Simple forward target picker based on existing conversations list.
class ForwardTargetPickerModalWrapper extends StatelessWidget {
  const ForwardTargetPickerModalWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ConversationsListInteractor>(
      create: (context) => ConversationsListInteractor(
        conversationsListRepo:
            context.read<IAppEnvPreset>().createConversationsListRepo(),
      ),
      child: BlocProvider<AllConversationsListBloc>(
        create: (context) => AllConversationsListBloc(
          conversationsListInteractor:
              context.read<ConversationsListInteractor>(),
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
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppModalCard(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.messageContextActionForward,
                          style: context.textScheme.title.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _queryController,
                    labelText: l10n.search,
                    textInputAction: TextInputAction.search,
                    maxSymbols: 200,
                    onChanged: (_) => setState(() {}),
                    onFocusChange: (_) => setState(() {}),
                    onSubmitted: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: context.colorScheme.outlineVariant),
            Expanded(
              child: BlocBuilder<AllConversationsListBloc,
                  AllConversationsListState>(
                builder: (context, state) {
                  if (state is AllConversationsListLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is AllConversationsListFailureState) {
                    return InfoWidget(
                      icon: Icons.error_outline,
                      text: AppExceptionsTranslator.translate(
                        context,
                        state.failure,
                      ),
                      useErrorStyle: true,
                    );
                  }

                  if (state is! AllConversationsListLoadedState) {
                    return const SizedBox.shrink();
                  }

                  final String query = _queryController.text.trim().toLowerCase();

                  final items = state.conversationTiles.where((tile) {
                    if (query.isEmpty) return true;
                    final inTitle =
                        tile.title.toLowerCase().contains(query);
                    final inDescription =
                        (tile.description ?? '').toLowerCase().contains(query);
                    final inLastMessage =
                        (tile.lastMessageText ?? '').toLowerCase().contains(
                              query,
                            );
                    return inTitle || inDescription || inLastMessage;
                  }).toList();

                  if (items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 24,
                        ),
                        child: Text(
                          l10n.nothingFound,
                          style: context.textScheme.caption.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final tile = items[index];
                      return ListTile(
                        title: Text(tile.title),
                        subtitle: tile.description != null
                            ? Text(tile.description!)
                            : null,
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

