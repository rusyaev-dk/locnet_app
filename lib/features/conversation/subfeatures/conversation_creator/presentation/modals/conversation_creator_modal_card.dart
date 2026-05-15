import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_creator/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ConversationCreatorModalWrapper extends StatelessWidget {
  const ConversationCreatorModalWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ConversationCreatorInteractor>(
      create: (context) =>
          ConversationCreatorInteractor(logger: context.read<ILogger>()),
      child: BlocProvider<ConversationCreatorBloc>(
        create: (BuildContext context) {
          return ConversationCreatorBloc(
            conversationCreatorInteractor: context
                .read<ConversationCreatorInteractor>(),
            logger: context.read<ILogger>(),
          );
        },
        child: child,
      ),
    );
  }
}

class ConversationCreatorModalCard extends StatefulWidget {
  const ConversationCreatorModalCard({super.key});

  @override
  State<ConversationCreatorModalCard> createState() =>
      _ConversationCreatorModalCardState();
}

class _ConversationCreatorModalCardState
    extends State<ConversationCreatorModalCard> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    final ConversationCreatorState state = context
        .read<ConversationCreatorBloc>()
        .state;

    if (state.title != null && state.title!.isNotEmpty) {
      _titleController.text = state.title!;
      _titleController.selection = TextSelection.fromPosition(
        TextPosition(offset: _titleController.text.length),
      );
    }

    if (state.description != null && state.description!.isNotEmpty) {
      _descriptionController.text = state.description!;
      _descriptionController.selection = TextSelection.fromPosition(
        TextPosition(offset: _descriptionController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).maybePop(),
      },
      child: AppModalCard(
        maxWidth: 480,
        verticalInset: 56,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ConversationCreatorHeader(),
            Expanded(
              child: BlocListener<ConversationCreatorBloc, ConversationCreatorState>(
                listenWhen:
                    (
                      ConversationCreatorState previous,
                      ConversationCreatorState current,
                    ) {
                      return previous.success != current.success;
                    },
                listener: (BuildContext context, ConversationCreatorState state) {
                  if (state.success) {
                    Navigator.of(context).maybePop();
                  }
                },
                child: BlocBuilder<ConversationCreatorBloc, ConversationCreatorState>(
                  builder: (BuildContext context, ConversationCreatorState state) {
                    final Object? failure = state.failure;

                    if (failure != null && !state.success && !state.isPending) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                        child: InfoWidget(
                          icon: Icons.error,
                          text: AppExceptionsTranslator.translate(
                            context,
                            failure,
                          ),
                          useErrorStyle: true,
                          iconAnimationEffect: const ShakeEffect(),
                        ),
                      );
                    }

                    return _ConversationCreatorView(
                      titleController: _titleController,
                      descriptionController: _descriptionController,
                      state: state,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationCreatorView extends StatelessWidget {
  const _ConversationCreatorView({
    required this.titleController,
    required this.descriptionController,
    required this.state,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final ConversationCreatorState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final bloc = context.read<ConversationCreatorBloc>();
    final bool isPending = state.isPending;

    final radii = context.radii;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ModalSectionCaption(text: l10n.conversationType),
          const SizedBox(height: 10),
          _ModalSurfacePanel(
            radii: radii,
            colorScheme: colorScheme,
            child: ConversationTypeSelector(
              selectedConversationType: state.selectedConversationType,
            ),
          ),
          const SizedBox(height: 22),
          _ModalSectionCaption(text: l10n.conversationTitle),
          const SizedBox(height: 10),
          _ModalSurfacePanel(
            radii: radii,
            colorScheme: colorScheme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  isActive: !isPending,
                  controller: titleController,
                  labelText: l10n.conversationTitle,
                  textInputAction: TextInputAction.next,
                  maxSymbols: 40,
                  onChanged: (String? value) {
                    bloc.add(UpdateConversationTitleEvent(title: value));
                  },
                  onFocusChange: (String? value) {
                    bloc.add(UpdateConversationTitleEvent(title: value));
                  },
                  onSubmitted: (String? value) {
                    bloc.add(UpdateConversationTitleEvent(title: value));
                  },
                  errorText: state.titleException != null
                      ? AppExceptionsTranslator.translate(
                          context,
                          state.titleException,
                        )
                      : null,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  isActive: !isPending,
                  controller: descriptionController,
                  labelText: l10n.conversationDescription,
                  textInputAction: TextInputAction.newline,
                  maxLines: 4,
                  maxSymbols: 2000,
                  onChanged: (String? value) {
                    bloc.add(
                      UpdateConversationDescriptionEvent(description: value),
                    );
                  },
                  onFocusChange: (String? value) {
                    bloc.add(
                      UpdateConversationDescriptionEvent(description: value),
                    );
                  },
                  onSubmitted: (String? value) {
                    bloc.add(
                      UpdateConversationDescriptionEvent(description: value),
                    );
                  },
                  errorText: state.descriptionException != null
                      ? AppExceptionsTranslator.translate(
                          context,
                          state.descriptionException,
                        )
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _ConversationCreatorSubmitButton(isPending: isPending),
        ],
      ),
    );
  }
}

/// Uppercase section label aligned with unified search / list section styling.
class _ModalSectionCaption extends StatelessWidget {
  const _ModalSectionCaption({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 0.8,
        height: 1.2,
      ),
    );
  }
}

/// Raised panel on modal `secondary` backdrop: `surface` fill + outline (inputs theme).
class _ModalSurfacePanel extends StatelessWidget {
  const _ModalSurfacePanel({
    required this.child,
    required this.radii,
    required this.colorScheme,
  });

  final Widget child;
  final AppRadii radii;
  final AppColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: radii.largeRadius,
        border: Border.all(color: colorScheme.outline),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: child,
    );
  }
}

class _ConversationCreatorSubmitButton extends StatelessWidget {
  const _ConversationCreatorSubmitButton({required this.isPending});

  final bool isPending;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocSelector<ConversationCreatorBloc, ConversationCreatorState, bool>(
      selector: (ConversationCreatorState state) =>
          state.title != null && state.title!.isNotEmpty,
      builder: (BuildContext context, bool canCreateConversation) {
        return AppPrimaryButton(
          width: double.infinity,
          text: l10n.create,
          onPressed: () {
            context.read<ConversationCreatorBloc>().add(
              const SubmitConversationEvent(),
            );
          },
          isActive: canCreateConversation && !isPending,
          isLoading: isPending,
        );
      },
    );
  }
}
