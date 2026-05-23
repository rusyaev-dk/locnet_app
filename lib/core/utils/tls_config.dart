import 'package:locnet_app/core/utils/tls_config_stub.dart'
    if (dart.library.io) 'package:locnet_app/core/utils/tls_config_io.dart'
    as tls_impl;

void applyTlsConfig({required bool checkCert}) =>
    tls_impl.applyTlsConfig(checkCert: checkCert);
