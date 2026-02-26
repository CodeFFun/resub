import 'package:flutter/material.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';

class ShopListCard extends StatelessWidget {
  final ShopEntity shop;
  final VoidCallback onTap;

  const ShopListCard({super.key, required this.shop, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final addressParts = <String>[];
    if (shop.addressLabel != null && shop.addressLabel!.isNotEmpty) {
      addressParts.add(shop.addressLabel!);
    }
    if (shop.addressLine1 != null && shop.addressLine1!.isNotEmpty) {
      addressParts.add(shop.addressLine1!);
    }
    final addressDisplay = addressParts.join(' - ');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          leading: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: shop.shopBanner != null && shop.shopBanner!.isNotEmpty
                  ? Image.network(
                      '${ApiEndpoints.baseUrl}${shop.shopBanner}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported,
                          color: Colors.grey.shade600,
                        );
                      },
                    )
                  : Icon(
                      Icons.store_outlined,
                      size: 32,
                      color: Colors.grey.shade600,
                    ),
            ),
          ),
          title: Text(
            shop.name ?? 'Unnamed Shop',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                shop.categoryName ?? 'No Category',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 4),
              Text(
                addressDisplay.isNotEmpty ? addressDisplay : 'No Address',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
