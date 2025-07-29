import 'package:hive_flutter/hive_flutter.dart';
import 'local_storage_repository.dart';

/// A generic implementation of local storage using Hive
class HiveLocalStorageRepository implements LocalStorageRepository {
  final Box box;

  HiveLocalStorageRepository(this.box);

  @override
  Future<void> saveData(String key, dynamic data) async {
    await box.put(key, data);
  }

  @override
  T? getData<T>(String key, {T? defaultValue}) {
    return box.get(key, defaultValue: defaultValue) as T?;
  }

  @override
  Future<void> removeData(String key) async {
    await box.delete(key);
  }

  @override
  bool hasData(String key) {
    return box.containsKey(key);
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}
