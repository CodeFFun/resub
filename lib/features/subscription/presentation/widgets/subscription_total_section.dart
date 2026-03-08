import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';

class SubscriptionTotalSection extends StatelessWidget {
  final double totalPrice;

  const SubscriptionTotalSection({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: appColors?.cardBackground ?? theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Per Cycle (Selected):',
            style: TextStyle(
              fontSize: 14,
              color:
                  appColors?.mutedText ??
                  colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          Text(
            '\$${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
