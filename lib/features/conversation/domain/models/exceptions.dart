import 'package:locnet_app/app/app.dart';

final class ConversationCreatorExceptionCodes {
  const ConversationCreatorExceptionCodes._();

  static const AppExceptionCode emptyField = AppExceptionCode(
    'conversationCreator.emptyField',
  );

  static const AppExceptionCode dataTooLong = AppExceptionCode(
    'conversationCreator.dataTooLong',
  );

  static const AppExceptionCode createFailed = AppExceptionCode(
    'conversationCreator.createFailed',
  );
}
