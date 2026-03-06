import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/features/graph/domain/entities/shop_dashboard_overview_entity.dart';

class TopProductsRevenueChart extends StatelessWidget {
  final List<TopProductByRevenueEntity> products;

  const TopProductsRevenueChart({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    if (products.isEmpty) {
      return Center(
        child: Text(
          'No top product data',
          style: TextStyle(
            fontSize: 16,
            color:
                appColors?.secondaryText ??
                colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      );
    }

    final maxRevenue = products
        .map((e) => e.revenue)
        .fold<double>(0, (prev, element) => math.max(prev, element));

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final labelWidth = isMobile ? 108.0 : 180.0;

        return SingleChildScrollView(
          child: Column(
            children: [
              for (final product in products)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: labelWidth,
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 34,
                              width: maxRevenue == 0
                                  ? 0
                                  : (product.revenue / maxRevenue) *
                                        constraints.maxWidth,
                              color:
                                  appColors?.deepBrand ?? colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: isMobile ? 38 : 48,
                        child: Text(
                          product.revenue.toStringAsFixed(0),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
