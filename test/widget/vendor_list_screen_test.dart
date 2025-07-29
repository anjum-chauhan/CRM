import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vendor_management_system/data/models/vendor.dart';
import 'package:vendor_management_system/data/repository/vendor_repository.dart';
import 'package:vendor_management_system/presentation/vendors/vendor_detail_screen.dart';
import 'package:vendor_management_system/presentation/vendors/vendor_list_screen.dart';
import 'package:vendor_management_system/presentation/vendors/vendor_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockVendorRepository extends Mock implements VendorRepository {}

void main() {
  late MockVendorRepository mockRepository;

  final testVendors = [
    Vendor(vendorId: 1, name: 'Test Vendor 1', location: 'Location 1', rating: 4.5, category: 'Category 1'),
    Vendor(vendorId: 2, name: 'Test Vendor 2', location: 'Location 2', rating: 4.0, category: 'Category 2'),
    Vendor(vendorId: 3, name: 'Another Vendor', location: 'Location 3', rating: 3.5, category: 'Category 1'),
  ];

  setUp(() {
    mockRepository = MockVendorRepository();
  });

  

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const VendorListScreen(),
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
      errorBuilder: (context, state) => const SizedBox.shrink(),
    );

    return ProviderScope(
      overrides: [
        vendorRepoProvider.overrideWithValue(mockRepository),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  group('VendorListScreen Widget Tests', () {
    testWidgets('renders list of vendors', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        when(() => mockRepository.getVendors()).thenAnswer((_) async => testVendors);
        when(() => mockRepository.getFavoriteVendors()).thenReturn([]);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Vendor 1'), findsOneWidget);
      expect(find.text('Test Vendor 2'), findsOneWidget);
      expect(find.text('Another Vendor'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(3));
      });
    });

    testWidgets('search filters vendors correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        when(() => mockRepository.getVendors()).thenAnswer((_) async => testVendors);
        when(() => mockRepository.getFavoriteVendors()).thenReturn([]);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Vendor 1'), findsOneWidget);
      expect(find.text('Test Vendor 2'), findsOneWidget);
      expect(find.text('Another Vendor'), findsNothing);
      });
    });

    testWidgets('navigates to detail page when vendor is tapped', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        when(() => mockRepository.getVendors()).thenAnswer((_) async => testVendors);
        when(() => mockRepository.getFavoriteVendors()).thenReturn([]);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find and tap the first vendor's ListTile
      final firstVendorTile = find.ancestor(
        of: find.text('Test Vendor 1'),
        matching: find.byType(ListTile),
      );
      expect(firstVendorTile, findsOneWidget, reason: 'Should find the vendor ListTile');
      
      await tester.tap(firstVendorTile);
      await tester.pumpAndSettle();

      // Assert we're on the detail page
      expect(find.byType(VendorDetailScreen), findsOneWidget);
      
      // Verify the vendor name is in the app bar
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Test Vendor 1'),
        ),
        findsOneWidget,
      );
      
      // Verify vendor details are displayed
      final locationFinder = find.textContaining('Location 1');
      final categoryFinder = find.textContaining('Category 1');
      final ratingFinder = find.textContaining('4.5');
      
      expect(locationFinder, findsOneWidget);
      expect(categoryFinder, findsOneWidget);
      expect(ratingFinder, findsOneWidget);
      });
    });

    testWidgets('shows empty state when no vendors match search', (tester) async {
      await mockNetworkImagesFor(() async {
        // Arrange
        when(() => mockRepository.getVendors()).thenAnswer((_) async => testVendors);
        when(() => mockRepository.getFavoriteVendors()).thenReturn([]);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter search query that won't match any vendors
      await tester.enterText(find.byType(TextField), 'XYZ');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No vendors found'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
      });
    });
  });
}
