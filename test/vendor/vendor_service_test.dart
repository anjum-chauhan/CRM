import 'package:flutter_test/flutter_test.dart';
import 'package:vendor_management_system/data/services/vendor_service.dart';
import 'package:vendor_management_system/data/models/vendor.dart';

void main() {
  late VendorService vendorService;

  setUp(() {
    vendorService = VendorService();
  });

  group('VendorService Tests', () {
    test('fetchVendors returns list of 50 vendors', () async {
      final vendors = await vendorService.fetchVendors();
      
      expect(vendors.length, equals(50));
      expect(vendors.first, isA<Vendor>());
      expect(vendors.every((v) => v.vendorId >= 0), isTrue);
      expect(vendors.every((v) => v.name.isNotEmpty), isTrue);
      expect(vendors.every((v) => v.rating >= 3 && v.rating <= 5), isTrue);
    });

    test('fetchVendors returns unique vendorIds', () async {
      final vendors = await vendorService.fetchVendors();
      final vendorIds = vendors.map((v) => v.vendorId).toSet();
      
      expect(vendorIds.length, equals(vendors.length),
          reason: 'All vendor IDs should be unique');
    });

    test('fetchVendors has valid rating range', () async {
      final vendors = await vendorService.fetchVendors();
      
      for (final vendor in vendors) {
        expect(vendor.rating, greaterThanOrEqualTo(3.0));
        expect(vendor.rating, lessThanOrEqualTo(5.0));
      }
    });
  });
}
