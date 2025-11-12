enum AppEnvType {
  /// Dev (mock environment)
  dev('dev.env'),

  /// Stage (hybrid: network + mocks)
  stage('stage.env'),

  /// Production
  prod('prod.env');

  const AppEnvType(this.value);

  final String value;

  @override
  String toString() => value;
}
