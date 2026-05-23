import 'dart:io';

/// Disables TLS certificate verification for all dart:io HTTP clients when false.
void applyTlsConfig({required bool checkCert}) {
  if (!checkCert) {
    HttpOverrides.global = _PermissiveTlsOverrides();
  }
}

class _PermissiveTlsOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
