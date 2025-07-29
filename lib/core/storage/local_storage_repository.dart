/// Generic interface for local storage operations
abstract class LocalStorageRepository {
  /// Saves data to local storage
  Future<void> saveData(String key, dynamic data);

  /// Retrieves data from local storage
  T? getData<T>(String key, {T? defaultValue});

  /// Removes data from local storage
  Future<void> removeData(String key);

  /// Checks if data exists in local storage
  bool hasData(String key);

  /// Clears all data from local storage
  Future<void> clear();
}
