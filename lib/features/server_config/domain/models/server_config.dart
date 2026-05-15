import 'package:equatable/equatable.dart';

final class ServerConfig extends Equatable {
  const ServerConfig({
    required this.baseUrl,
    required this.socketBaseUrl,
  });

  final String baseUrl;
  final String socketBaseUrl;

  @override
  List<Object?> get props => [baseUrl, socketBaseUrl];
}
