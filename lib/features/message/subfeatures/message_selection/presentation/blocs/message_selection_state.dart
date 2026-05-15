part of 'message_selection_cubit.dart';

class MessageSelectionState extends Equatable {
  const MessageSelectionState({
    required this.conversationId,
    required this.conversationType,
    required this.selectedMessageIds,
    required this.isSelectionMode,
  });

  final String conversationId;
  final ConversationType conversationType;
  final Set<MessageId> selectedMessageIds;
  final bool isSelectionMode;

  int get selectedCount => selectedMessageIds.length;

  bool isSelected(MessageId id) => selectedMessageIds.contains(id);

  MessageSelectionState copyWith({
    String? conversationId,
    ConversationType? conversationType,
    Set<MessageId>? selectedMessageIds,
    bool? isSelectionMode,
  }) {
    return MessageSelectionState(
      conversationId: conversationId ?? this.conversationId,
      conversationType: conversationType ?? this.conversationType,
      selectedMessageIds: selectedMessageIds ?? this.selectedMessageIds,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
    );
  }

  @override
  List<Object> get props => <Object>[
        conversationId,
        conversationType,
        selectedMessageIds,
        isSelectionMode,
      ];
}

