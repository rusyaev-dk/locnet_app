abstract interface class IKeyValueStorage {
  Future<bool> write<T>({required String key, required T value});
  Future<T?> read<T>({required String key});
  Future<bool> delete({required String key});
  Future<bool> clear();
}
