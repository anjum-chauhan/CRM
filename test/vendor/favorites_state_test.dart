import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vendor_management_system/data/models/vendor.dart';
import 'package:vendor_management_system/data/repository/vendor_repository.dart';
import 'package:vendor_management_system/presentation/vendors/vendor_provider.dart';

class MockVendorRepository extends Mock implements VendorRepository {}

void main() {
  late MockVendorRepository mockRepository;
  late ProviderContainer container;
  final testVendor = Vendor(
    vendorId: 1,
    name: 'Test Vendor',
    location: 'Test Location',
    rating: 4.0,
    category: 'Test',
  );

  setUp(() {
    mockRepository = MockVendorRepository();
    // Ensure getFavoriteVendors always returns a List<Vendor>
    when(() => mockRepository.getFavoriteVendors()).thenReturn([]);
    container = ProviderContainer(overrides: [
      vendorRepoProvider.overrideWithValue(mockRepository),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  group('Favorites State Management Tests', () {
    test('initial state is empty', () {
      when(() => mockRepository.getFavoriteVendors()).thenReturn([]);
      final favorites = container.read(favoriteVendorsProvider);
      expect(favorites, isEmpty);
    });

    test('toggleFavorite adds vendor when not favorite', () async {
      when(() => mockRepository.getFavoriteVendors()).thenReturn([]);
      when(() => mockRepository.isFavorite(testVendor.vendorId)).thenReturn(false);
      when(() => mockRepository.addToFavorites(testVendor)).thenAnswer((_) async {});
      
      final notifier = container.read(favoriteVendorsProvider.notifier);
      await notifier.toggleFavorite(testVendor);

      verify(() => mockRepository.addToFavorites(testVendor)).called(1);
      when(() => mockRepository.getFavoriteVendors()).thenReturn([testVendor]);
      
      final favorites = container.read(favoriteVendorsProvider);
      expect(favorites.length, equals(1));
      expect(favorites.first.vendorId, equals(testVendor.vendorId));
    });

    test('toggleFavorite removes vendor when already favorite', () async {
      when(() => mockRepository.getFavoriteVendors()).thenReturn([testVendor]);
      when(() => mockRepository.isFavorite(testVendor.vendorId)).thenReturn(true);
      when(() => mockRepository.removeFromFavorites(testVendor.vendorId)).thenAnswer((_) async {});
      
      final notifier = container.read(favoriteVendorsProvider.notifier);
      await notifier.toggleFavorite(testVendor);

      verify(() => mockRepository.removeFromFavorites(testVendor.vendorId)).called(1);
      when(() => mockRepository.getFavoriteVendors()).thenReturn([]);
      
      final favorites = container.read(favoriteVendorsProvider);
      expect(favorites, isEmpty);
    });

    test('isFavorite returns correct status', () {
      when(() => mockRepository.isFavorite(testVendor.vendorId)).thenReturn(true);
      final notifier = container.read(favoriteVendorsProvider.notifier);
      
      expect(notifier.isFavorite(testVendor.vendorId), isTrue);
      verify(() => mockRepository.isFavorite(testVendor.vendorId)).called(1);
    });
  });
}
