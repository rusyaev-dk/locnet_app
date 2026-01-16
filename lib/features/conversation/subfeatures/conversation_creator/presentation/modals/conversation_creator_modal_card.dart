import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/core/core.dart';
import 'package:locnet_app/features/conversation/data/data.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/conversation/subfeatures/conversation_creator/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class ConversationCreatorModalWrapper extends StatelessWidget {
  const ConversationCreatorModalWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ConversationCreatorInteractor>(
      create: (context) => ConversationCreatorInteractor(
        conversationRepo: context.read<IConversationRepo>(),
        logger: context.read<ILogger>(),
      ),
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
    final colorScheme = context.colorScheme;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 420,
            maxHeight: MediaQuery.of(context).size.height - 48,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Material(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child:
                    BlocListener<
                      ConversationCreatorBloc,
                      ConversationCreatorState
                    >(
                      listenWhen:
                          (
                            ConversationCreatorState previous,
                            ConversationCreatorState current,
                          ) {
                            return previous.success != current.success;
                          },
                      listener:
                          (
                            BuildContext context,
                            ConversationCreatorState state,
                          ) {
                            if (state.success) {
                              Navigator.of(context).maybePop();
                            }
                          },
                      child:
                          BlocBuilder<
                            ConversationCreatorBloc,
                            ConversationCreatorState
                          >(
                            builder:
                                (
                                  BuildContext context,
                                  ConversationCreatorState state,
                                ) {
                                  final Object? failure = state.failure;

                                  if (failure != null &&
                                      !state.success &&
                                      !state.isPending) {
                                    return InfoWidget(
                                      icon: Icons.error,
                                      text: AppExceptionsTranslator.translate(
                                        context,
                                        failure,
                                      ),
                                      iconAnimationEffect: const ShakeEffect(),
                                    );
                                  }

                                  return _ConversationCreatorView(
                                    titleController: _titleController,
                                    descriptionController:
                                        _descriptionController,
                                    state: state,
                                  );
                                },
                          ),
                    ),
              ),
            ),
          ),
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
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    final ConversationCreatorBloc bloc = context
        .read<ConversationCreatorBloc>();

    final bool isPending = state.isPending;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ConversationCreatorHeader(),
        Divider(height: 1, color: colorScheme.outlineVariant),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                ConversationTypeSelector(
                  selectedConversationType: state.selectedConversationType,
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
                _ConversationCreatorSubmitButton(isPending: isPending),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ConversationCreatorSubmitButton extends StatelessWidget {
  const _ConversationCreatorSubmitButton({required this.isPending});

  final bool isPending;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocSelector<
      ConversationCreatorBloc,
      ConversationCreatorState,
      bool
    >(
      selector: (ConversationCreatorState state) {
        final ConversationCreatorBloc bloc = context
            .read<ConversationCreatorBloc>();
        return bloc.canCreateConversation();
      },
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
