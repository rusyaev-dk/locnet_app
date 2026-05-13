abstract interface class IDbEncryptionKeyProvider {
  /// Возвращает hex-ключ шифрования БД.
  /// При первом вызове — генерирует и сохраняет в хранилище.
  /// При последующих — читает из хранилища.
  Future<String> getOrCreateKey();
}
