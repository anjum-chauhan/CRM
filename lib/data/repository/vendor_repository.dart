import '../models/vendor.dart';
import '../services/vendor_service.dart';
import '../../core/storage/local_storage_repository.dart';

class VendorRepository {
  final VendorService _service;
  final LocalStorageRepository _localStorage;
  static const String FAVORITES_KEY = 'vendor_favorites';

  VendorRepository(this._service, this._localStorage);

  /// Fetches all vendors from the remote service
  Future<List<Vendor>> getVendors() => _service.fetchVendors();

  /// Gets the list of favorite vendors from local storage
  List<Vendor> getFavoriteVendors() {
    final favoritesList = _localStorage.getData<List>(FAVORITES_KEY, defaultValue: []);
    return favoritesList
        ?.map((item) => item is Map ? 
          Vendor.fromJson(Map<String, dynamic>.from(item)) : 
          item)
        .whereType<Vendor>()
        .toList() ?? [];
  }

  /// Adds a vendor to favorites
  Future<void> addToFavorites(Vendor vendor) async {
    final favorites = getFavoriteVendors();
    if (!favorites.any((v) => v.vendorId == vendor.vendorId)) {
      favorites.add(vendor);
      await _localStorage.saveData(FAVORITES_KEY, favorites.map((v) => v.toJson()).toList());
    }
  }

  /// Removes a vendor from favorites
  Future<void> removeFromFavorites(int vendorId) async {
    final favorites = getFavoriteVendors();
    favorites.removeWhere((v) => v.vendorId == vendorId);
    await _localStorage.saveData(FAVORITES_KEY, favorites.map((v) => v.toJson()).toList());
  }

  /// Checks if a vendor is in favorites
  bool isFavorite(int vendorId) {
    return getFavoriteVendors().any((v) => v.vendorId == vendorId);
  }
}