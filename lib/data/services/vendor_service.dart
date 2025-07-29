import 'dart:math';
import 'dart:async';
import 'package:faker/faker.dart';
import '../models/vendor.dart';

class VendorService {
  Future<List<Vendor>> fetchVendors() async {
    await Future.delayed(Duration(seconds: 2));
    final faker = Faker();
    return List.generate(50, (index) => Vendor(
      vendorId: index,
      name: faker.company.name(),
      location: faker.address.city(),
      rating: (3 + Random().nextDouble() * 2), 
      category: faker.job.title(),
    ));
  }
}