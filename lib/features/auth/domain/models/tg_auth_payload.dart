import 'package:locnet_app/features/auth/domain/domain.dart';

final class TelegramAuthPayload extends AuthPayload {
  const TelegramAuthPayload({
    required this.initData,
    required this.userId,
    required this.username,
    required super.data,
  });

  final String initData;
  final String userId;
  final String? username;

  @override
  List<Object?> get props => [initData, userId, username];
}
