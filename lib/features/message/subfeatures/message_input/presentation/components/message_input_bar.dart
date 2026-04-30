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

    final TextStyle baseStyle = textScheme.label.copyWith(
      fontSize: 16,
      color: colorScheme.onSurface,
    );

    _textEditingController = MessageRichInputController(
      baseStyle: baseStyle,
      boldStyle: baseStyle.copyWith(fontWeight: FontWeight.w700),
      italicStyle: baseStyle.copyWith(fontStyle: FontStyle.italic),
      underlineStyle: baseStyle.copyWith(decoration: TextDecoration.underline),
      codeStyle: baseStyle.copyWith(fontFamily: 'monospace'),
      codeBlockStyle: baseStyle.copyWith(
        fontFamily: 'monospace',
        height: 1.25,
        backgroundColor: colorScheme.onSurface.withAlpha(18),
      ),
      strikeStyle: baseStyle.copyWith(decoration: TextDecoration.lineThrough),
      linkStyle: baseStyle.copyWith(
        color: colorScheme.primary,
        decoration: TextDecoration.none,
      ),
    );
    _textEditingController!.addListener(_persistDraft);
    _restoreDraftIfNeeded();
  }

  @override
  void dispose() {
    _persistDraft();
    _textEditingController?.removeListener(_persistDraft);
    _textEditingController?.dispose();
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

  void _handleAttachPressed() {
    _messageAttachmentsCubit?.pickFiles();
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

    return BlocBuilder<MessageAttachmentsCubit, MessageAttachmentsState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          _persistDraft();
        });
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: colorScheme.surfaceBright,
                child: Row(
                  children: <Widget>[
                    RoundedIconButton(
                      icon: Icons.attach_file,
                      backgroundColor: colorScheme.surfaceBright,
                      onPressed: _handleAttachPressed,
                      buttonSize: 35,
                      iconSize: 25,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: MessageInputField(
                        controller: controller,
                        hintText: '${l10n.message}...',
                        maxSymbols: 4096,
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 5),
                    EmojiButton(textController: controller),
                    const SizedBox(width: 5),
                    RoundedIconButton(
                      icon: Icons.send,
                      backgroundColor: colorScheme.surfaceBright,
                      onPressed: _send,
                      buttonSize: 35,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
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
