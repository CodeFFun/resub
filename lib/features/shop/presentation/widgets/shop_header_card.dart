import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/core/api/api_endpoints.dart';
import '../../domain/entities/shop_entity.dart';

class ShopHeaderCard extends StatelessWidget {
  final ShopEntity shop;

  const ShopHeaderCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            color: appColors?.cardBackground ?? theme.cardColor,
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
                        color: appColors?.cardBackground ?? theme.cardColor,
                        child: Icon(
                          Icons.restaurant,
                          size: 80,
                          color:
                              appColors?.mutedText ??
                              colorScheme.onSurface.withValues(alpha: 0.65),
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
                      color: appColors?.deepBrand ?? colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 20,
                        color:
                            appColors?.mutedText ??
                            colorScheme.onSurface.withValues(alpha: 0.65),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          shop.addressLabel ?? shop.addressLine1 ?? 'Location',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color:
                                    appColors?.secondaryText ??
                                    colorScheme.onSurface.withValues(
                                      alpha: 0.8,
                                    ),
                              ),
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
