abstract final class ServerConfigValidator {
  static String? validate({
    required String baseUrl,
    required String socketUrl,
  }) {
    const urlRegex = r'^https?://.+';
    if (!RegExp(urlRegex).hasMatch(baseUrl.trim())) {
      return 'base';
    }
    if (!RegExp(urlRegex).hasMatch(socketUrl.trim())) {
      return 'socket';
    }
    return null;
  }
}
