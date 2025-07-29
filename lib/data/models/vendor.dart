
import 'package:equatable/equatable.dart';

class Vendor extends Equatable{
  final int vendorId;
  final String name;
  final String location;
  final double rating;
  final String category;

  const Vendor({
    required this.vendorId,
    required this.name,
    required this.location,
    required this.rating,
    required this.category,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        vendorId: json['vendorId'],
        name: json['name'],
        location: json['location'],
        rating: (json['rating'] as num).toDouble(),
        category: json['category'],
      );

  Map<String, dynamic> toJson() => {
        'vendorId': vendorId,
        'name': name,
        'location': location,
        'rating': rating,
        'category': category,
      };
  
   @override
  List<Object?> get props => [vendorId, name, location, rating, category];
}