import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/vendor_repository.dart';
import '../../core/storage/hive_storage_provider.dart';
import '../../../data/services/vendor_service.dart';
import '../../../data/models/vendor.dart';

/// SECTION 1: Repository Providers

/// Service provider for vendor data
final vendorServiceProvider = Provider((ref) => VendorService());

/// Vendor repository provider that combines service and storage
final vendorRepoProvider = Provider((ref) {
  final vendorService = ref.watch(vendorServiceProvider);
  final localStorage = ref.watch(localStorageRepositoryProvider);
  return VendorRepository(vendorService, localStorage);
});

/// SECTION 2: Vendor List Management

/// Provides the combined list of vendors with favorites first
final vendorListProvider = FutureProvider<List<Vendor>>((ref) async {
  final repo = ref.watch(vendorRepoProvider);
  
  // Fetch both remote and local data
  final vendors = await repo.getVendors();
  final favorites = repo.getFavoriteVendors();
  
  // Create a Set of favorite IDs for efficient lookup
  final favoriteIds = favorites.map((v) => v.vendorId).toSet();
  
  // Filter out vendors that are already in favorites
  final nonFavorites = vendors.where(
    (vendor) => !favoriteIds.contains(vendor.vendorId)
  ).toList();
  
  // Return combined list with favorites first
  return [...favorites, ...nonFavorites];
});

/// SECTION 3: Search Functionality

/// Stores the current search query
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provides a filtered list of vendors based on the search query
final filteredVendorsProvider = Provider<List<Vendor>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final asyncValue = ref.watch(vendorListProvider);
  
  return asyncValue.when(
    data: (vendors) => vendors
        .where(
        (vendor) {
          return vendor.name.toLowerCase().contains(query) ||
              vendor.category.toLowerCase().contains(query) ||
              vendor.location.toLowerCase().contains(query);
        }).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// SECTION 4: Favorites Management

/// Manages favorite vendors state and operations
final favoriteVendorsProvider = StateNotifierProvider<FavoriteVendorsNotifier, List<Vendor>>((ref) {
  final repo = ref.watch(vendorRepoProvider);
  return FavoriteVendorsNotifier(repo);
});

/// Notifier class that handles favorite vendor operations
class FavoriteVendorsNotifier extends StateNotifier<List<Vendor>> {
  final VendorRepository _repository;
  
  FavoriteVendorsNotifier(this._repository) : super([]) {
    state = _repository.getFavoriteVendors();
  }

  /// Toggles the favorite status of a vendor and updates both local storage and state
  Future<void> toggleFavorite(Vendor vendor) async {
    if (_repository.isFavorite(vendor.vendorId)) {
      await _repository.removeFromFavorites(vendor.vendorId);
      state = state.where((v) => v.vendorId != vendor.vendorId).toList();
    } else {
      await _repository.addToFavorites(vendor);
      state = [...state, vendor];
    }
  }

  /// Checks if a vendor is marked as favorite
  bool isFavorite(int vendorId) => _repository.isFavorite(vendorId);
}