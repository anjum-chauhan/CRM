import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vendor_management_system/core/storage/storage_keys.dart';
import 'local_storage_repository.dart';
import 'hive_local_storage_repository.dart';

/// Provider for local storage implementation
final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  return HiveLocalStorageRepository(Hive.box(StorageKeys.APP_STORAGE_BOX));
});

