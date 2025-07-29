import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'data/models/vendor.dart';
import 'presentation/vendors/vendor_detail_screen.dart';
import 'presentation/vendors/vendor_list_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => VendorListScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final vendor = state.extra as Vendor;
            return VendorDetailScreen(vendor: vendor);
          },
        ),
      ],
    ),
  ],
);

class VendorApp extends StatelessWidget {
  const VendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Vendor Management System',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}