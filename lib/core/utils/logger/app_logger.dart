import 'package:locnet_app/core/utils/utils.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AppLogger implements ILogger {
  AppLogger({required Talker talker}) : _talker = talker;

  final Talker _talker;

  @override
  void error(Object error, [StackTrace? stackTrace]) {
    _talker.error(error, stackTrace);
  }

  @override
  void exception(Object exception, [StackTrace? stackTrace]) {
    _talker.handle(exception, stackTrace);
  }

  @override
  void info(String message) {
    _talker.info(message);
  }

  @override
  void log(String message) {
    _talker.log(message);
  }

  @override
  void warning(String message) {
    _talker.warning(message);
  }
}
