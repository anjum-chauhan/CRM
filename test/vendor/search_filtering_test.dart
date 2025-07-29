
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vendor_management_system/data/models/vendor.dart';
import 'package:vendor_management_system/data/repository/vendor_repository.dart';
import 'package:vendor_management_system/presentation/vendors/vendor_provider.dart';

class MockVendorRepository extends Mock implements VendorRepository {}

void main() {
  late ProviderContainer container;
  late MockVendorRepository mockRepository;
  final testVendors = [
    Vendor(vendorId: 1, name: 'Alpha Electronics', location: 'NY', rating: 4.5, category: 'Electronics'),
    Vendor(vendorId: 2, name: 'Beta Fashion', location: 'LA', rating: 4.8, category: 'Fashion'),
    Vendor(vendorId: 3, name: 'Gamma Gadgets', location: 'SF', rating: 4.2, category: 'Electronics'),
  ];

  setUp(() {
    mockRepository = MockVendorRepository();
    container = ProviderContainer(overrides: [
      vendorRepoProvider.overrideWithValue(mockRepository),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  group('Search Filtering Logic', () {
    test('searchQueryProvider initial state is empty', () {
      final searchQuery = container.read(searchQueryProvider);
      expect(searchQuery, isEmpty);
    });

    test('returns all vendors when search query is empty', () async {
      // Pre-populate the vendorListProvider with test data
      when(() => mockRepository.getVendors()).thenAnswer((_) async => testVendors);
      when(() => mockRepository.getFavoriteVendors()).thenReturn([]);

      // First, wait for the vendorListProvider to be populated
      await container.read(vendorListProvider.future);
      
      final vendors = container.read(filteredVendorsProvider);
      expect(vendors.length, 3);
      verify(() => mockRepository.getVendors()).called(1);
    });

    test('filters vendors based on lowercase name match', () async {
      when(() => mockRepository.getVendors()).thenAnswer((_) async => testVendors);
      when(() => mockRepository.getFavoriteVendors()).thenReturn([]);

      // First, wait for the vendorListProvider to be populated
      await container.read(vendorListProvider.future);

      // Set search query
      container.read(searchQueryProvider.notifier).state = 'alpha';

      final vendors = container.read(filteredVendorsProvider);
      expect(vendors.length, 1);
      expect(vendors.first.name, equals('Alpha Electronics'));
      verify(() => mockRepository.getVendors()).called(1);
    });

    test('filters vendors case-insensitively', () async {
      when(() => mockRepository.getVendors()).thenAnswer((_) async => testVendors);
      when(() => mockRepository.getFavoriteVendors()).thenReturn([]);

      // First, wait for the vendorListProvider to be populated
      await container.read(vendorListProvider.future);

      // Test with uppercase query
      container.read(searchQueryProvider.notifier).state = 'FASHION';

      final vendors = container.read(filteredVendorsProvider);
      expect(vendors.length, 1);
      expect(vendors.first.name, equals('Beta Fashion'));
      verify(() => mockRepository.getVendors()).called(1);
    });

    test('returns empty list for no matches', () async {
      when(() => mockRepository.getVendors()).thenAnswer((_) async => testVendors);
      when(() => mockRepository.getFavoriteVendors()).thenReturn([]);

      // First, wait for the vendorListProvider to be populated
      await container.read(vendorListProvider.future);

      // Set search query with no matches
      container.read(searchQueryProvider.notifier).state = 'xyz';

      final vendors = container.read(filteredVendorsProvider);
      expect(vendors.isEmpty, true);
      verify(() => mockRepository.getVendors()).called(1);
    });

    test('filters by location', () async {
      when(() => mockRepository.getVendors()).thenAnswer((_) async => testVendors);
      when(() => mockRepository.getFavoriteVendors()).thenReturn([]);

      // First, wait for the vendorListProvider to be populated
      await container.read(vendorListProvider.future);

      container.read(searchQueryProvider.notifier).state = 'ny';

      final vendors = container.read(filteredVendorsProvider);
      expect(vendors.length, 1);
      expect(vendors.first.location, equals('NY'));
      verify(() => mockRepository.getVendors()).called(1);
    });

    test('filters by category', () async {
      when(() => mockRepository.getVendors()).thenAnswer((_) async => testVendors);
      when(() => mockRepository.getFavoriteVendors()).thenReturn([]);

      // First, wait for the vendorListProvider to be populated
      await container.read(vendorListProvider.future);

      container.read(searchQueryProvider.notifier).state = 'electronics';

      final vendors = container.read(filteredVendorsProvider);
      expect(vendors.length, 2);
      expect(vendors.every((v) => v.category == 'Electronics'), true);
      verify(() => mockRepository.getVendors()).called(1);
    });
  });
}
