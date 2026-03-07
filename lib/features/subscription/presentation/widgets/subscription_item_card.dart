import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/core/utils/responsive_utils.dart';
import 'package:resub/features/subscription/domain/entities/product_info_entity.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';

class SubscriptionItemCard extends StatelessWidget {
  final SubscriptionEntity subscription;
  final SubscriptionProductInfo product;
  final bool isSelected;
  final VoidCallback onSelectionChanged;
  final Function(int) onQuantityChanged;
  final Function(int) onFrequencyChanged;
  final Function(bool) onActiveChanged;

  const SubscriptionItemCard({
    super.key,
    required this.subscription,
    required this.product,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onQuantityChanged,
    required this.onFrequencyChanged,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    final productName = product.name ?? 'Unknown Product';
    final quantity =
        product.quantity ?? subscription.subscriptionPlanId?.quantity ?? 0;
    final basePrice = product.basePrice ?? 0.0;
    final frequency = subscription.subscriptionPlanId?.frequency ?? 1;
    final pricePerCycle = subscription.subscriptionPlanId?.pricePerCycle ?? 0.0;
    final isActive = subscription.subscriptionPlanId?.active ?? false;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.rSpacing(12),
        vertical: context.rSpacing(8),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? (appColors?.deepBrand ?? colorScheme.primary).withValues(
                  alpha: 0.4,
                )
              : (appColors?.border ?? theme.dividerColor),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(context.rRadius(12)),
        color: isSelected
            ? (appColors?.deepBrand ?? colorScheme.primary).withValues(
                alpha: 0.08,
              )
            : (appColors?.cardBackground ?? theme.cardColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(context.rSpacing(12)),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onSelectionChanged(),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: context.rFont(15),
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.rHeight(4)),
                      Text(
                        'Base Price: \$${basePrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: context.rFont(13),
                          color:
                              appColors?.mutedText ??
                              colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rSpacing(12)),
            child: Divider(
              height: 1,
              color: appColors?.border ?? theme.dividerColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(context.rSpacing(12)),
            child: Column(
              children: [
                // Price and Quantity controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price/Cycle: \$${pricePerCycle.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: context.rFont(14),
                            fontWeight: FontWeight.w600,
                            color: appColors?.deepBrand ?? colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: context.rHeight(4)),
                        Text(
                          'Quantity: $quantity',
                          style: TextStyle(
                            fontSize: context.rFont(12),
                            color:
                                appColors?.mutedText ??
                                colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    // Quantity Controls
                    _buildControlWidget(
                      context: context,
                      label: 'Qty',
                      value: quantity,
                      onDecrement: quantity > 1
                          ? () => onQuantityChanged(quantity - 1)
                          : null,
                      onIncrement: () => onQuantityChanged(quantity + 1),
                    ),
                  ],
                ),
                SizedBox(height: context.rHeight(12)),
                // Frequency controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Frequency',
                          style: TextStyle(
                            fontSize: context.rFont(13),
                            fontWeight: FontWeight.w500,
                            color:
                                appColors?.secondaryText ??
                                colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: context.rHeight(4)),
                        Text(
                          'Every $frequency day${frequency > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: context.rFont(12),
                            color:
                                appColors?.mutedText ??
                                colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    // Frequency Controls
                    _buildControlWidget(
                      context: context,
                      label: 'Days',
                      value: frequency,
                      onDecrement: frequency > 1
                          ? () => onFrequencyChanged(frequency - 1)
                          : null,
                      onIncrement: () => onFrequencyChanged(frequency + 1),
                    ),
                  ],
                ),
                SizedBox(height: context.rHeight(12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: context.rFont(13),
                            fontWeight: FontWeight.w500,
                            color:
                                appColors?.secondaryText ??
                                colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: context.rHeight(4)),
                        Text(
                          isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: context.rFont(12),
                            color:
                                appColors?.mutedText ??
                                colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    Switch(value: isActive, onChanged: onActiveChanged),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlWidget({
    required BuildContext context,
    required String label,
    required int value,
    required VoidCallback? onDecrement,
    required VoidCallback onIncrement,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.rFont(11),
            color:
                appColors?.mutedText ??
                colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: context.rHeight(4)),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: appColors?.border ?? theme.dividerColor),
            borderRadius: BorderRadius.circular(context.rRadius(8)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: context.rWidth(36),
                height: context.rHeight(36),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onDecrement,
                    child: Icon(
                      Icons.remove,
                      size: context.rIcon(16),
                      color: onDecrement != null
                          ? (appColors?.secondaryText ??
                                colorScheme.onSurface.withValues(alpha: 0.7))
                          : (appColors?.mutedText ??
                                colorScheme.onSurface.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
              ),
              Container(
                width: context.rWidth(40),
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: TextStyle(
                    fontSize: context.rFont(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: context.rWidth(36),
                height: context.rHeight(36),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onIncrement,
                    child: Icon(
                      Icons.add,
                      size: context.rIcon(16),
                      color:
                          appColors?.secondaryText ??
                          colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
