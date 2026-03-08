import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/core/constants/esewa_constants.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';
import 'package:resub/features/order/presentation/view_models/order_view_model.dart';
import 'package:resub/features/order/presentation/widgets/order_item_card.dart';
import 'package:resub/features/order/presentation/widgets/proceed_checkout_button.dart';
import 'package:resub/features/order/presentation/widgets/select_all_items_widget.dart';
import 'package:resub/features/order/presentation/widgets/total_price_section.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';
import 'package:resub/features/payment/presentation/view_models/payment_view_model.dart';

class OrderPageScreen extends ConsumerStatefulWidget {
  final List<OrderEntity> order;

  const OrderPageScreen({super.key, required this.order});

  @override
  ConsumerState<OrderPageScreen> createState() => _OrderPageScreenState();
}

class _OrderPageScreenState extends ConsumerState<OrderPageScreen> {
  final Map<String, Map<String, bool>> _selectedItemsByOrder = {};
  bool _globalSelectAll = false;

  @override
  void initState() {
    super.initState();
    _initializeSelections();
  }

  @override
  void didUpdateWidget(OrderPageScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order != widget.order) {
      _initializeSelections();
    }
  }

  void _initializeSelections() {
    _globalSelectAll = false;
    _selectedItemsByOrder.clear();

    for (var order in widget.order) {
      final orderId = order.id ?? '';
      _selectedItemsByOrder[orderId] = {};

      if (order.orderItemsId != null) {
        for (var item in order.orderItemsId!) {
          _selectedItemsByOrder[orderId]![item.id ?? ''] = false;
        }
      }
    }
  }

  void _toggleGlobalSelectAll() {
    setState(() {
      _globalSelectAll = !_globalSelectAll;
      for (var orderId in _selectedItemsByOrder.keys) {
        for (var itemId in _selectedItemsByOrder[orderId]!.keys) {
          _selectedItemsByOrder[orderId]![itemId] = _globalSelectAll;
        }
      }
    });
  }

  void _toggleItemSelection(String orderId, String itemId) {
    setState(() {
      if (_selectedItemsByOrder[orderId] != null) {
        _selectedItemsByOrder[orderId]![itemId] =
            !(_selectedItemsByOrder[orderId]![itemId] ?? false);
        _updateGlobalSelectAllState();
      }
    });
  }

  void _updateGlobalSelectAllState() {
    bool allSelected = true;

    for (var orderItems in _selectedItemsByOrder.values) {
      if (orderItems.isEmpty) continue;

      if (!orderItems.values.every((selected) => selected)) {
        allSelected = false;
        break;
      }
    }

    _globalSelectAll = allSelected;
  }

  Future<void> _updateQuantity(
    OrderItemEntity orderItem,
    int newQuantity,
  ) async {
    if (newQuantity < 1) return;
    final basePrice = orderItem.productId?.basePrice ?? 0.0;
    final discount = orderItem.productId?.discount ?? 0;
    final discountedPrice = basePrice * (1 - discount / 100);
    final newUnitPrice = discountedPrice * newQuantity;

    final updatedItem = orderItem.copyWith(
      quantity: newQuantity,
      unitPrice: newUnitPrice,
    );

    if (orderItem.id != null) {
      await ref
          .read(orderViewModelProvider.notifier)
          .updateOrderItem(
            orderItemId: orderItem.id!,
            orderItemEntity: updatedItem,
          );
    }
  }

  Future<void> _deleteOrder(String orderId) async {
    await ref
        .read(orderViewModelProvider.notifier)
        .deleteOrder(orderId: orderId);
  }

  List<OrderItemEntity> _getSelectedItems() {
    List<OrderItemEntity> allSelectedItems = [];

    for (var order in widget.order) {
      final orderId = order.id ?? '';
      if (order.orderItemsId != null &&
          _selectedItemsByOrder[orderId] != null) {
        final selectedInThisOrder = order.orderItemsId!
            .where(
              (item) => _selectedItemsByOrder[orderId]![item.id ?? ''] ?? false,
            )
            .toList();
        allSelectedItems.addAll(selectedInThisOrder);
      }
    }

    return allSelectedItems;
  }

  List<Map<String, String>> _getSelectedItemsWithOrderIdMapping() {
    List<Map<String, String>> mapping = [];

    for (var order in widget.order) {
      final orderId = order.id ?? '';
      if (order.orderItemsId != null &&
          _selectedItemsByOrder[orderId] != null) {
        final selectedInThisOrder = order.orderItemsId!
            .where(
              (item) => _selectedItemsByOrder[orderId]![item.id ?? ''] ?? false,
            )
            .toList();
        for (var item in selectedInThisOrder) {
          mapping.add({'itemId': item.id ?? '', 'orderId': orderId});
        }
      }
    }

    return mapping;
  }

  void _proceedToCheckout() async {
    final selectedItems = _getSelectedItems();
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one item to proceed'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final totalPrice = selectedItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.unitPrice ?? 0.0),
    );

    // Get unique order IDs for the selected items
    final itemOrderMapping = _getSelectedItemsWithOrderIdMapping();
    final orderIds = itemOrderMapping
        .map((mapping) => mapping['orderId'] ?? '')
        .where((orderId) => orderId.isNotEmpty)
        .toSet()
        .toList();

    await ref
        .read(paymentViewModelProvider.notifier)
        .initiateEsewaPayment(
          productName: 'Order Payment',
          amount: totalPrice.toString(),
          orderIds: orderIds,
          isTestEnvironment: kEsewaUseTestEnvironment,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    final hasOrders = widget.order.isNotEmpty;
    final hasAnyItems = widget.order.any(
      (order) => order.orderItemsId != null && order.orderItemsId!.isNotEmpty,
    );
    ref.listen<PaymentState>(paymentViewModelProvider, (previous, next) {
      if (next.status == PaymentStatus.esewaPaymentFailed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${next.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (next.status == PaymentStatus.created) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment record created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details'), elevation: 0),
      body: !hasOrders || !hasAnyItems
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color:
                        appColors?.mutedText ??
                        colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No items in order',
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          appColors?.mutedText ??
                          colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Global Select All at the top
                SelectAllItemsWidget(
                  selectAll: _globalSelectAll,
                  onToggle: _toggleGlobalSelectAll,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Display each order
                        ...widget.order.map((order) {
                          final orderId = order.id ?? '';
                          final orderItems = order.orderItemsId ?? [];

                          if (orderItems.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Order Header Section
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      appColors?.cardBackground ??
                                      theme.cardColor,
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          appColors?.border ??
                                          theme.dividerColor,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (order.shopId?.name != null) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.store,
                                                size: 20,
                                                color:
                                                    appColors?.secondaryText ??
                                                    colorScheme.onSurface
                                                        .withValues(alpha: 0.7),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                order.shopId!.name!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            iconSize: 20,
                                            color: Colors.red,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () =>
                                                _deleteOrder(orderId),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                    if (order.deliveryType != null) ...[
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.local_shipping,
                                            size: 18,
                                            color:
                                                appColors?.mutedText ??
                                                colorScheme.onSurface
                                                    .withValues(alpha: 0.5),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Delivery: ${order.deliveryType}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  appColors?.secondaryText ??
                                                  colorScheme.onSurface
                                                      .withValues(alpha: 0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                    if (order.scheduleFor != null) ...[
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.schedule,
                                            size: 18,
                                            color:
                                                appColors?.mutedText ??
                                                colorScheme.onSurface
                                                    .withValues(alpha: 0.5),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Scheduled: ${_formatDate(order.scheduleFor!)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  appColors?.secondaryText ??
                                                  colorScheme.onSurface
                                                      .withValues(alpha: 0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: orderItems.length,
                                itemBuilder: (context, index) {
                                  final orderItem = orderItems[index];
                                  final itemId = orderItem.id ?? '';
                                  final isSelected =
                                      _selectedItemsByOrder[orderId]?[itemId] ??
                                      false;

                                  return OrderItemCard(
                                    orderItem: orderItem,
                                    order: order,
                                    isSelected: isSelected,
                                    onSelectionChanged: () =>
                                        _toggleItemSelection(orderId, itemId),
                                    onQuantityChanged: (newQuantity) =>
                                        _updateQuantity(orderItem, newQuantity),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                // Bottom Proceed Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: appColors?.border ?? theme.dividerColor,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        TotalPriceSection(totalPrice: _calculateTotalPrice()),
                        ProceedCheckoutButton(onPressed: _proceedToCheckout),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  double _calculateTotalPrice() {
    double total = 0.0;

    for (var order in widget.order) {
      final orderId = order.id ?? '';
      if (order.orderItemsId != null &&
          _selectedItemsByOrder[orderId] != null) {
        for (var item in order.orderItemsId!) {
          if (_selectedItemsByOrder[orderId]![item.id ?? ''] ?? false) {
            total += item.unitPrice ?? 0.0;
          }
        }
      }
    }

    return total;
  }
}
