import 'package:flutter/material.dart';
import 'package:resub/core/api/api_endpoints.dart';
import '../../domain/entities/shop_entity.dart';

class ShopHeaderCard extends StatelessWidget {
  final ShopEntity shop;

  const ShopHeaderCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            image: shop.shopBanner != null
                ? DecorationImage(
                    image: NetworkImage(
                      '${ApiEndpoints.baseUrl}${shop.shopBanner!}',
                    ),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: shop.shopBanner == null
              ? Center(
                  child: Image.asset(
                    'assets/images/ramen.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.restaurant,
                          size: 80,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                )
              : null,
        ),
        // Stacked Card with Shop Details
        Positioned(
          bottom: -40,
          left: 16,
          right: 16,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Shop Name
                  Text(
                    shop.name ?? 'Shop Name',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          shop.addressLabel ?? shop.addressLine1 ?? 'Location',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
