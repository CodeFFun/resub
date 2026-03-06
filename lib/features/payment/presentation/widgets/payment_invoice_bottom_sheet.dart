import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';

Future<void> showPaymentInvoiceBottomSheet({
  required BuildContext context,
  required PaymentEntity payment,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _PaymentInvoiceBottomSheet(payment: payment);
    },
  );
}

class _PaymentInvoiceBottomSheet extends StatelessWidget {
  final PaymentEntity payment;

  const _PaymentInvoiceBottomSheet({required this.payment});

  String _formatAmount(double amount) {
    return 'Rs.${amount.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _displayOrFallback(String? value, String fallback) {
    if (value == null || value.trim().isEmpty) return fallback;
    return value;
  }

  List<_InvoiceItem> _buildInvoiceItems() {
    final items = <_InvoiceItem>[];

    // For each order, check either orderItemsId OR subscriptionId
    for (final order in payment.orders ?? const []) {
      // Path 1: Order has orderItemsId (products)
      if (order.orderItemsId != null && order.orderItemsId!.isNotEmpty) {
        final firstOrderItem = order.orderItemsId!.first;
        final productName = _displayOrFallback(
          firstOrderItem.productId?.name,
          'Unknown Product',
        );
        final quantity = firstOrderItem.quantity ?? 1;
        final unitPrice = firstOrderItem.unitPrice ?? 0;
        items.add(
          _InvoiceItem(
            productName: productName,
            quantity: quantity,
            price: unitPrice,
          ),
        );
      }
      // Path 2: Order has subscriptionId - use order.subscription first, fallback to payment.subscription
      else if (order.subscriptionId != null &&
          order.subscriptionId!.isNotEmpty) {
        // Try to use the order's populated subscription data first
        final subscription = order.subscription ?? payment.subscription;
        final plan = subscription?.subscriptionPlanId;

        if (plan != null) {
          final subscriptionProduct =
              (plan.productId != null && plan.productId!.isNotEmpty)
              ? plan.productId!.first
              : null;

          final productName = _displayOrFallback(
            subscriptionProduct?.name,
            'Subscription',
          );
          final quantity = subscriptionProduct?.quantity ?? plan.quantity ?? 1;
          final unitPrice = (plan.pricePerCycle ?? 0).toDouble();

          items.add(
            _InvoiceItem(
              productName: productName,
              quantity: quantity,
              price: unitPrice,
            ),
          );
        }
      }
    }

    if (items.isNotEmpty) return items;

    // Fallback for subscription payments when order items are absent.
    final plan = payment.subscription?.subscriptionPlanId;
    if (plan != null) {
      final subscriptionProduct =
          (plan.productId != null && plan.productId!.isNotEmpty)
          ? plan.productId!.first
          : null;

      final productName = _displayOrFallback(
        subscriptionProduct?.name,
        'Subscription',
      );
      final quantity = subscriptionProduct?.quantity ?? plan.quantity ?? 1;
      final unitPrice = (plan.pricePerCycle ?? 0).toDouble();

      items.add(
        _InvoiceItem(
          productName: productName,
          quantity: quantity,
          price: unitPrice,
        ),
      );
    }

    if (items.isNotEmpty) return items;

    // Last fallback when backend sent minimal data only.
    return [
      _InvoiceItem(
        productName:
            '${_displayOrFallback(payment.provider, 'Payment').toUpperCase()} Payment',
        quantity: 1,
        price: payment.amount,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    final amount = _formatAmount(payment.amount);
    final paidDate = _formatDate(payment.paidAt ?? payment.createdAt);
    final invoiceItems = _buildInvoiceItems();

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: appColors?.cardBackground ?? theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color:
                        appColors?.mutedText ??
                        colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Date: $paidDate',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Payment ID: ${_displayOrFallback(payment.id, 'N/A')}',
                style: TextStyle(
                  color:
                      appColors?.mutedText ??
                      colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _InvoiceSection(
                      title: 'FROM',
                      mainText: _displayOrFallback(
                        payment.shopId?.name ?? payment.shopId?.id,
                        'Unknown Shop',
                      ),
                      subText:
                          'Status: ${_displayOrFallback(payment.status, 'pending')}',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InvoiceSection(
                      title: 'TO',
                      mainText: _displayOrFallback(
                        payment.userId?.userName ?? payment.userId?.userId,
                        'Unknown User',
                      ),
                      subText:
                          'Provider: ${_displayOrFallback(payment.provider, 'N/A')}',
                      alignRight: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'ITEMS',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: appColors?.border ?? theme.dividerColor,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              'Product Name',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Quantity',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Price',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: appColors?.border ?? theme.dividerColor,
                    ),
                    ...invoiceItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                item.productName,
                                style: TextStyle(color: colorScheme.onSurface),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${item.quantity}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      appColors?.mutedText ??
                                      colorScheme.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: Text(
                                _formatAmount(item.price),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Invoice Total: $amount',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvoiceItem {
  final String productName;
  final int quantity;
  final double price;

  const _InvoiceItem({
    required this.productName,
    required this.quantity,
    required this.price,
  });
}

class _InvoiceSection extends StatelessWidget {
  final String title;
  final String mainText;
  final String subText;
  final bool alignRight;

  const _InvoiceSection({
    required this.title,
    required this.mainText,
    required this.subText,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    final textAlign = alignRight ? TextAlign.right : TextAlign.left;

    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: textAlign,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          mainText,
          textAlign: textAlign,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subText,
          textAlign: textAlign,
          style: TextStyle(
            color:
                appColors?.mutedText ??
                colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
