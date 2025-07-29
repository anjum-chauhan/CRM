import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/vendor.dart';
import '../vendors/vendor_provider.dart';

class VendorCard extends ConsumerWidget {
  final Vendor vendor;

  const VendorCard({super.key, required this.vendor});

   @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteVendorsProvider.select((favorites) => favorites.any((v) => v.vendorId == vendor.vendorId)));
    final avatarUrl = 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(vendor.name)}&background=random';

    return GestureDetector(
      onTap: () => context.push('/details', extra: vendor),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: ListTile(
          leading: Hero(
            tag: 'vendor_${vendor.vendorId}',
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: Image.network(avatarUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.person, size: 24, color: Colors.grey);
                  },
                ),
              ),
            ),
          ),
          title: Text(vendor.name),
          subtitle: Text('${vendor.category} • ${vendor.rating.toStringAsFixed(1)}'),
          trailing: IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null),
            onPressed: () => ref.read(favoriteVendorsProvider.notifier).toggleFavorite(vendor),
          ),
        ),
      ),
    );
  }
}