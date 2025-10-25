import 'package:equatable/equatable.dart';
import 'package:locnet_app/core/core.dart';

/// One-off UI message with optional interpolation args.
class AppMessage extends Equatable {
  AppMessage({required IMessageKey key, Map<String, Object>? args})
    : _key = key,
      _args = args ?? const <String, Object>{},
      id = Object();

  final IMessageKey _key;
  final Map<String, Object> _args;

  final Object id;

  IMessageKey get key => _key;
  Map<String, Object> get args => _args;

  @override
  List<Object?> get props => [id, _key, _args];
}
