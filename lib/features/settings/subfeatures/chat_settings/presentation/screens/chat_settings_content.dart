import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locnet_app/app/app.dart';
import 'package:locnet_app/features/settings/presentation/components/components.dart';
import 'package:locnet_app/features/settings/subfeatures/chat_settings/presentation/blocs/blocs.dart';

/// Chats settings section.
class ChatSettingsContent extends StatefulWidget {
  const ChatSettingsContent({super.key});

  @override
  State<ChatSettingsContent> createState() => _ChatSettingsContentState();
}

class _ChatSettingsContentState extends State<ChatSettingsContent> {
  bool _autoScroll = true;
  bool _sendOnEnter = true;
  bool _shiftEnterNewLine = true;
  bool _saveDrafts = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatSettingsCubit, ChatSettingsState>(
      builder: (context, state) {
        if (state is! ChatSettingsLoadedState) {
          return const Center(child: CircularProgressIndicator());
        }
        return _ChatSettingsBody(
          autoScroll: _autoScroll,
          sendOnEnter: _sendOnEnter,
          shiftEnterNewLine: _shiftEnterNewLine,
          saveDrafts: _saveDrafts,
          onAutoScrollChanged: (v) => setState(() => _autoScroll = v),
          onSendOnEnterChanged: (v) => setState(() => _sendOnEnter = v),
          onShiftEnterNewLineChanged: (v) =>
              setState(() => _shiftEnterNewLine = v),
          onSaveDraftsChanged: (v) => setState(() => _saveDrafts = v),
        );
      },
    );
  }
}

class _ChatSettingsBody extends StatelessWidget {
  const _ChatSettingsBody({
    required this.autoScroll,
    required this.sendOnEnter,
    required this.shiftEnterNewLine,
    required this.saveDrafts,
    required this.onAutoScrollChanged,
    required this.onSendOnEnterChanged,
    required this.onShiftEnterNewLineChanged,
    required this.onSaveDraftsChanged,
  });

  final bool autoScroll;
  final bool sendOnEnter;
  final bool shiftEnterNewLine;
  final bool saveDrafts;
  final ValueChanged<bool> onAutoScrollChanged;
  final ValueChanged<bool> onSendOnEnterChanged;
  final ValueChanged<bool> onShiftEnterNewLineChanged;
  final ValueChanged<bool> onSaveDraftsChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(
            title: l10n.settingsChats,
            description: 'Настройте поведение чатов и параметры отображения.',
          ),

          // ── Поведение ─────────────────────────────────────
          SettingsGroupCard(
            title: 'Поведение чатов',
            children: [
              SettingsSwitchTile(
                title: 'Автопрокрутка к новым сообщениям',
                value: autoScroll,
                onChanged: onAutoScrollChanged,
              ),
              SettingsSwitchTile(
                title: 'Отправка по Enter',
                subtitle: 'Нажмите Enter, чтобы отправить сообщение',
                value: sendOnEnter,
                onChanged: onSendOnEnterChanged,
              ),
              SettingsSwitchTile(
                title: 'Shift+Enter — новая строка',
                enabled: sendOnEnter,
                value: shiftEnterNewLine,
                onChanged: onShiftEnterNewLineChanged,
              ),
              SettingsSwitchTile(
                title: 'Сохранять черновики',
                value: saveDrafts,
                onChanged: onSaveDraftsChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
