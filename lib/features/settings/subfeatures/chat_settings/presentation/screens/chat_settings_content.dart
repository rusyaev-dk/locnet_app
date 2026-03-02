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

  bool _saveHistory = true;
  bool _autoDeleteOld = false;

  bool _showAvatars = true;
  bool _showTimestamps = true;
  bool _groupMessages = true;

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
          saveHistory: _saveHistory,
          autoDeleteOld: _autoDeleteOld,
          showAvatars: _showAvatars,
          showTimestamps: _showTimestamps,
          groupMessages: _groupMessages,
          onAutoScrollChanged: (v) => setState(() => _autoScroll = v),
          onSendOnEnterChanged: (v) => setState(() => _sendOnEnter = v),
          onShiftEnterNewLineChanged: (v) =>
              setState(() => _shiftEnterNewLine = v),
          onSaveDraftsChanged: (v) => setState(() => _saveDrafts = v),
          onSaveHistoryChanged: (v) => setState(() => _saveHistory = v),
          onAutoDeleteOldChanged: (v) => setState(() => _autoDeleteOld = v),
          onShowAvatarsChanged: (v) => setState(() => _showAvatars = v),
          onShowTimestampsChanged: (v) => setState(() => _showTimestamps = v),
          onGroupMessagesChanged: (v) => setState(() => _groupMessages = v),
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
    required this.saveHistory,
    required this.autoDeleteOld,
    required this.showAvatars,
    required this.showTimestamps,
    required this.groupMessages,
    required this.onAutoScrollChanged,
    required this.onSendOnEnterChanged,
    required this.onShiftEnterNewLineChanged,
    required this.onSaveDraftsChanged,
    required this.onSaveHistoryChanged,
    required this.onAutoDeleteOldChanged,
    required this.onShowAvatarsChanged,
    required this.onShowTimestampsChanged,
    required this.onGroupMessagesChanged,
  });

  final bool autoScroll;
  final bool sendOnEnter;
  final bool shiftEnterNewLine;
  final bool saveDrafts;
  final bool saveHistory;
  final bool autoDeleteOld;
  final bool showAvatars;
  final bool showTimestamps;
  final bool groupMessages;
  final ValueChanged<bool> onAutoScrollChanged;
  final ValueChanged<bool> onSendOnEnterChanged;
  final ValueChanged<bool> onShiftEnterNewLineChanged;
  final ValueChanged<bool> onSaveDraftsChanged;
  final ValueChanged<bool> onSaveHistoryChanged;
  final ValueChanged<bool> onAutoDeleteOldChanged;
  final ValueChanged<bool> onShowAvatarsChanged;
  final ValueChanged<bool> onShowTimestampsChanged;
  final ValueChanged<bool> onGroupMessagesChanged;

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
          const SizedBox(height: 20),

          // ── История ───────────────────────────────────────
          SettingsGroupCard(
            title: 'История',
            children: [
              SettingsSwitchTile(
                title: 'Сохранять историю чатов',
                value: saveHistory,
                onChanged: onSaveHistoryChanged,
              ),
              SettingsSwitchTile(
                title: 'Автоматическое удаление старых чатов',
                subtitle: 'Удалять чаты старше 90 дней',
                enabled: saveHistory,
                value: autoDeleteOld,
                onChanged: onAutoDeleteOldChanged,
              ),
              SettingsActionTile(
                title: 'Очистить историю',
                leadingIcon: Icons.delete_sweep_outlined,
                onTap: () {},
              ),
              SettingsActionTile(
                title: 'Удалить все чаты',
                leadingIcon: Icons.delete_forever_outlined,
                destructive: true,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Отображение ───────────────────────────────────
          SettingsGroupCard(
            title: 'Отображение',
            children: [
              SettingsSwitchTile(
                title: 'Показывать аватары',
                value: showAvatars,
                onChanged: onShowAvatarsChanged,
              ),
              SettingsSwitchTile(
                title: 'Показывать временные метки',
                value: showTimestamps,
                onChanged: onShowTimestampsChanged,
              ),
              SettingsSwitchTile(
                title: 'Группировать сообщения',
                subtitle: 'Объединять последовательные сообщения от одного отправителя',
                value: groupMessages,
                onChanged: onGroupMessagesChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
