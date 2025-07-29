
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vendor_management_system/core/storage/storage_keys.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(StorageKeys.APP_STORAGE_BOX);
  runApp(
    ProviderScope(
      child: VendorApp(),
    ),
  );
}