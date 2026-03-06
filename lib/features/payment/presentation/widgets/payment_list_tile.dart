import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';

class PaymentListTile extends StatelessWidget {
  final PaymentEntity payment;
  final String? userName;
  final String? shopName;
  final VoidCallback onEyePressed;

  const PaymentListTile({
    required this.payment,
    this.userName,
    this.shopName,
    required this.onEyePressed,
    super.key,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: appColors?.border ?? theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(payment.paidAt),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  userName ?? payment.userId?.userName ?? 'Unknown User',
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        appColors?.mutedText ??
                        colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  shopName ?? payment.shopId?.name ?? 'Unknown Shop',
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        appColors?.mutedText ??
                        colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onEyePressed,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: appColors?.cardBackground ?? theme.cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.visibility,
                color:
                    appColors?.secondaryText ??
                    colorScheme.onSurface.withValues(alpha: 0.7),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
