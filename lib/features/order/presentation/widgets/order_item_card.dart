import 'package:flutter/material.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItemEntity orderItem;
  final OrderEntity order;
  final bool isSelected;
  final VoidCallback onSelectionChanged;
  final Function(int) onQuantityChanged;

  const OrderItemCard({
    super.key,
    required this.orderItem,
    required this.order,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final productName = orderItem.productId?.name ?? 'Unknown Product';
    final shopName = order.shopId?.name ?? 'Unknown Shop';
    final quantity = orderItem.quantity ?? 0;
    final unitPrice = orderItem.unitPrice ?? 0.0;

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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Shop: $shopName',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price: \$${unitPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quantity: $quantity',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                // Quantity Controls
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
                            onTap: quantity > 1
                                ? () => onQuantityChanged(quantity - 1)
                                : null,
                            child: Icon(
                              Icons.remove,
                              size: 16,
                              color: quantity > 1
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
                          '$quantity',
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
                            onTap: () => onQuantityChanged(quantity + 1),
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
