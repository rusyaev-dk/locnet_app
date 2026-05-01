import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/conversation/subfeatures/private/presentation/presentation.dart';
import 'package:locnet_app/features/conversation/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/channel_publication/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/emoji_selector/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/group_message/presentation/presentation.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/domain/domain.dart';
import 'package:locnet_app/features/message/subfeatures/message_input/presentation/presentation.dart';
import 'package:locnet_app/uikit/uikit.dart';

class MessageInputBar extends StatefulWidget {
  const MessageInputBar({
    required this.conversationType,
    this.conversationId,
    this.draftContextId,
    this.replyToMessageId,
    this.onMessageSent,
    super.key,
  });

  final String? conversationId;
  final String? draftContextId;
  final ConversationType conversationType;
  final String? replyToMessageId;
  final VoidCallback? onMessageSent;

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  MessageRichInputController? _textEditingController;
  MessageAttachmentsCubit? _messageAttachmentsCubit;
  final EmojiSelectorController _emojiController = EmojiSelectorController();
  final GlobalKey _emojiButtonKey = GlobalKey();
  bool _emojiWarmUpStarted = false;
  bool _didRestoreDraft = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startEmojiWarmUpIfNeeded();
    });
  }

  void _startEmojiWarmUpIfNeeded() {
    if (_emojiWarmUpStarted) {
      return;
    }
    _emojiWarmUpStarted = true;
    warmUpEmojiRasterization();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messageAttachmentsCubit ??= context.read<MessageAttachmentsCubit>();

    if (_textEditingController != null) {
      return;
    }

    final colorScheme = context.colorScheme;
    final textScheme = context.textScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color inputForeground = isDark ? Colors.white : colorScheme.onSurface;

    final TextStyle baseStyle = textScheme.label.copyWith(
      fontSize: 16,
      color: inputForeground,
    );

    _textEditingController = MessageRichInputController(baseStyle: baseStyle);
    _textEditingController!.addListener(_persistDraft);
    _restoreDraftIfNeeded();
  }

  @override
  void dispose() {
    _persistDraft();
    _textEditingController?.removeListener(_persistDraft);
    _textEditingController?.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  String _draftKey() {
    final String identity =
        widget.conversationId ??
        widget.draftContextId ??
        'unknown-${widget.conversationType.name}';
    return '${widget.conversationType.name}::$identity';
  }

  void _restoreDraftIfNeeded() {
    if (_didRestoreDraft) {
      return;
    }
    _didRestoreDraft = true;
    final _MessageDraft? draft = _MessageDraftStore.instance.get(_draftKey());
    if (draft == null) {
      return;
    }
    final MessageMarkdownDecoded decoded = MessageMarkdownCodec.decodeInline(
      draft.text,
    );
    _textEditingController!
      ..value = _textEditingController!.value.copyWith(
        text: decoded.text,
        selection: TextSelection.collapsed(offset: decoded.text.length),
      )
      ..setRanges(decoded.ranges);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _messageAttachmentsCubit?.setFiles(draft.attachedFiles);
    });
  }

  void _persistDraft() {
    final MessageRichInputController? controller = _textEditingController;
    if (controller == null) {
      return;
    }
    final List<UploadableFile> files =
        _messageAttachmentsCubit?.state.files ?? [];
    final String markdown = MessageMarkdownCodec.encode(
      text: controller.text,
      ranges: controller.ranges,
    );
    _MessageDraftStore.instance.save(
      key: _draftKey(),
      draft: _MessageDraft(text: markdown, attachedFiles: files),
    );
  }

  Future<void> _handleAttachPressed() async {
    await _messageAttachmentsCubit?.pickFiles();
  }

  void _toggleEmojiPicker() {
    if (_emojiController.isShown) {
      _emojiController.hide();
      return;
    }
    _showEmojiPicker();
  }

  void _showEmojiPicker() {
    final OverlayState? overlayState = Overlay.maybeOf(
      context,
      rootOverlay: true,
    );
    if (overlayState == null) {
      return;
    }
    final RenderObject? overlayObject = overlayState.context.findRenderObject();
    final BuildContext? buttonContext = _emojiButtonKey.currentContext;

    if (overlayObject is! RenderBox || buttonContext == null) {
      return;
    }

    final RenderObject? buttonObject = buttonContext.findRenderObject();
    if (buttonObject is! RenderBox) {
      return;
    }

    final Offset buttonGlobal = buttonObject.localToGlobal(Offset.zero);
    final Offset buttonInOverlay = overlayObject.globalToLocal(buttonGlobal);

    final double overlayWidth = overlayObject.size.width;
    final double overlayHeight = overlayObject.size.height;

    final double panelHeight = overlayHeight * 0.35;
    const double gap = 8;

    final double desiredLeft = buttonInOverlay.dx;
    final double desiredTop = buttonInOverlay.dy - panelHeight - gap;

    final double clampedLeft = desiredLeft.clamp(8, overlayWidth - 8);
    final double clampedTop = desiredTop.clamp(8, overlayHeight - 8);

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(
        clampedLeft,
        clampedTop,
        buttonObject.size.width,
        buttonObject.size.height,
      ),
      Offset.zero & overlayObject.size,
    );

    final MessageRichInputController controller = _textEditingController!;

    _emojiController.show(
      context: context,
      position: position,
      textController: controller,
      onDismiss: () {
        _emojiController.hide();
      },
      onOverlayHoverChanged: ({required bool isHovered}) {},
    );
  }

  String _buildMarkdownForSend() {
    final MessageRichInputController controller = _textEditingController!;
    final String plainText = controller.text;
    if (plainText.trim().isEmpty) {
      return '';
    }

    return MessageMarkdownCodec.encode(
      text: plainText,
      ranges: controller.ranges,
    );
  }

  void _send() {
    final String markdown = _buildMarkdownForSend();
    final List<UploadableFile> files =
        _messageAttachmentsCubit?.state.files ?? [];
    if (markdown.isEmpty && files.isEmpty) {
      return;
    }

    switch (widget.conversationType) {
      case ConversationType.private:
        context.read<PrivateConversationBloc>().add(
          PrivateConversationSendMessageEvent(
            text: markdown,
            attachedFiles: files,
            replyToMessageId: widget.replyToMessageId,
          ),
        );
      case ConversationType.group:
        context.read<GroupMessageActionsCubit>().sendMessage(
          groupId: widget.conversationId!,
          attachedFiles: files,
          text: markdown,
          replyToMessageId: widget.replyToMessageId,
        );
      case ConversationType.channel:
        context.read<ChannelPublicationActionsCubit>().sendPublication(
          channelId: widget.conversationId!,
          attachedFiles: files,
          text: markdown,
          replyToPublicationId: widget.replyToMessageId,
        );
    }

    final MessageRichInputController _ = _textEditingController!
      ..clear()
      ..clearAllFormatting();
    _messageAttachmentsCubit?.clear();
    _MessageDraftStore.instance.clear(_draftKey());
    widget.onMessageSent?.call();
  }

  @override
  Widget build(BuildContext context) {
    final MessageRichInputController controller = _textEditingController!;

    final colorScheme = context.colorScheme;
    final l10n = context.l10n;

    // Rebuild when the input text changes (BlocBuilder alone only listens to attachments).
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? _) {
        return BlocBuilder<MessageAttachmentsCubit, MessageAttachmentsState>(
          builder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              _persistDraft();
            });

            final bool hasText = controller.text.trim().isNotEmpty;
            final String inputHint = widget.draftContextId != null
                ? l10n.draftChatHint
                : '${l10n.message}…';

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (state.files.isNotEmpty)
                  MessageAttachmentsPreview(
                    files: state.files,
                    onRemovePressed: (UploadableFile file) {
                      context.read<MessageAttachmentsCubit>().removeFile(file);
                    },
                    onOrderChanged: (List<UploadableFile> newOrder) {
                      context.read<MessageAttachmentsCubit>().applyNewOrder(
                        newOrder,
                      );
                    },
                  ),
                SafeArea(
                  top: false,
                  child: Container(
                    color: colorScheme.surface,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            border: Border.all(
                              color: colorScheme.outline,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _InputBarButton(
                                icon: Icons.attach_file,
                                size: 36,
                                iconSize: 20,
                                color: colorScheme.onSurfaceVariant,
                                onPressed: () => _handleAttachPressed(),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 120,
                                  ),
                                  child: MessageInputField(
                                    controller: controller,
                                    hintText: inputHint,
                                    maxSymbols: 4096,
                                    onSubmitted: (_) => _send(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              _InputBarButton(
                                key: _emojiButtonKey,
                                icon: Icons.sentiment_satisfied_alt_outlined,
                                size: 36,
                                iconSize: 20,
                                color: colorScheme.onSurfaceVariant,
                                onPressed: _toggleEmojiPicker,
                              ),
                              const SizedBox(width: 6),
                              _SendButton(
                                enabled: hasText || state.files.isNotEmpty,
                                colorScheme: colorScheme,
                                onPressed: _send,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _InputBarButton extends StatelessWidget {
  const _InputBarButton({
    required this.icon,
    required this.size,
    required this.color,
    required this.onPressed,
    this.iconSize = 18,
    super.key,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(Size(size, size)),
      style: IconButton.styleFrom(
        foregroundColor: color,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      icon: Icon(icon, size: iconSize),
      onPressed: onPressed,
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.enabled,
    required this.colorScheme,
    required this.onPressed,
  });

  final bool enabled;
  final AppColorScheme colorScheme;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(const Size(36, 36)),
      style: IconButton.styleFrom(
        backgroundColor: enabled
            ? colorScheme.primary
            : colorScheme.surfaceContainer,
        foregroundColor: enabled ? Colors.white : colorScheme.onSurfaceVariant,
        disabledBackgroundColor: colorScheme.surfaceContainer,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: const Icon(Icons.send, size: 18),
      onPressed: enabled ? onPressed : null,
    );
  }
}

final class _MessageDraft {
  const _MessageDraft({required this.text, required this.attachedFiles});

  final String text;
  final List<UploadableFile> attachedFiles;
}

final class _MessageDraftStore {
  _MessageDraftStore._();

  static final _MessageDraftStore instance = _MessageDraftStore._();
  final Map<String, _MessageDraft> _drafts = <String, _MessageDraft>{};

  _MessageDraft? get(String key) => _drafts[key];

  void save({required String key, required _MessageDraft draft}) {
    if (draft.text.trim().isEmpty && draft.attachedFiles.isEmpty) {
      _drafts.remove(key);
      return;
    }
    _drafts[key] = draft;
  }

  void clear(String key) {
    _drafts.remove(key);
  }
}
