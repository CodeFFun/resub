import 'package:flutter/material.dart';
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
    final productName = product.name ?? 'Unknown Product';
    final quantity =
        product.quantity ?? subscription.subscriptionPlanId?.quantity ?? 0;
    final basePrice = product.basePrice ?? 0.0;
    final frequency = subscription.subscriptionPlanId?.frequency ?? 1;
    final pricePerCycle = subscription.subscriptionPlanId?.pricePerCycle ?? 0.0;
    final isActive = subscription.subscriptionPlanId?.active ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.blue[200]! : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.blue[50] : Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Base Price: \$${basePrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Divider(height: 1, color: Colors.grey[200]),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
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
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quantity: $quantity',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    // Quantity Controls
                    _buildControlWidget(
                      label: 'Qty',
                      value: quantity,
                      onDecrement: quantity > 1
                          ? () => onQuantityChanged(quantity - 1)
                          : null,
                      onIncrement: () => onQuantityChanged(quantity + 1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Every $frequency day${frequency > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    // Frequency Controls
                    _buildControlWidget(
                      label: 'Days',
                      value: frequency,
                      onDecrement: frequency > 1
                          ? () => onFrequencyChanged(frequency - 1)
                          : null,
                      onIncrement: () => onFrequencyChanged(frequency + 1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: isActive,
                      onChanged: onActiveChanged,
                    ),
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
    required String label,
    required int value,
    required VoidCallback? onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onDecrement,
                    child: Icon(
                      Icons.remove,
                      size: 16,
                      color: onDecrement != null
                          ? Colors.grey[700]
                          : Colors.grey[300],
                    ),
                  ),
                ),
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 36,
                height: 36,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onIncrement,
                    child: Icon(Icons.add, size: 16, color: Colors.grey[700]),
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
