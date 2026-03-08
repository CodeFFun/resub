import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/core/constants/esewa_constants.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/presentation/state/order_state.dart';
import 'package:resub/features/order/presentation/view_models/order_view_model.dart';
import 'package:resub/features/payment/presentation/state/payment_state.dart';
import 'package:resub/features/payment/presentation/view_models/payment_view_model.dart';
import 'package:resub/features/subscription/domain/entities/product_info_entity.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart'
    hide ShopInfo;
import 'package:resub/features/subscription/presentation/view_models/subscription_view_model.dart';
import 'package:resub/features/subscription/presentation/widgets/subscription_confirm_button.dart';
import 'package:resub/features/subscription/presentation/widgets/subscription_item_card.dart';
import 'package:resub/features/subscription/presentation/widgets/subscription_select_all_widget.dart';
import 'package:resub/features/subscription/presentation/widgets/subscription_total_section.dart';

class SubscriptionPageScreen extends ConsumerStatefulWidget {
  final List<SubscriptionEntity> subscriptions;

  const SubscriptionPageScreen({super.key, required this.subscriptions});

  @override
  ConsumerState<SubscriptionPageScreen> createState() =>
      _SubscriptionPageScreenState();
}

class _SubscriptionPageScreenState
    extends ConsumerState<SubscriptionPageScreen> {
  final Map<String, Map<String, bool>> _selectedItemsBySubscription = {};
  bool _globalSelectAll = false;
  final List<String> _createdOrderIds = [];

  @override
  void initState() {
    super.initState();
    _initializeSelections();
  }

  @override
  void didUpdateWidget(SubscriptionPageScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subscriptions != widget.subscriptions) {
      _initializeSelections();
    }
  }

  void _initializeSelections() {
    _globalSelectAll = false;
    _selectedItemsBySubscription.clear();

    for (var subscription in widget.subscriptions) {
      final subscriptionId = subscription.id ?? '';
      _selectedItemsBySubscription[subscriptionId] = {};

      if (subscription.subscriptionPlanId?.productId != null) {
        for (var product in subscription.subscriptionPlanId!.productId!) {
          _selectedItemsBySubscription[subscriptionId]![product.id ?? ''] =
              false;
        }
      }
    }
  }

  void _toggleGlobalSelectAll() {
    setState(() {
      _globalSelectAll = !_globalSelectAll;
      for (var subscriptionId in _selectedItemsBySubscription.keys) {
        for (var productId
            in _selectedItemsBySubscription[subscriptionId]!.keys) {
          _selectedItemsBySubscription[subscriptionId]![productId] =
              _globalSelectAll;
        }
      }
    });
  }

  void _toggleItemSelection(String subscriptionId, String productId) {
    setState(() {
      if (_selectedItemsBySubscription[subscriptionId] != null) {
        _selectedItemsBySubscription[subscriptionId]![productId] =
            !(_selectedItemsBySubscription[subscriptionId]![productId] ??
                false);
        _updateGlobalSelectAllState();
      }
    });
  }

  void _updateGlobalSelectAllState() {
    bool allSelected = true;

    for (var subscriptionItems in _selectedItemsBySubscription.values) {
      if (subscriptionItems.isEmpty) continue;

      if (!subscriptionItems.values.every((selected) => selected)) {
        allSelected = false;
        break;
      }
    }

    _globalSelectAll = allSelected;
  }

  Future<void> _updateQuantity(
    SubscriptionEntity subscription,
    SubscriptionProductInfo product,
    int newQuantity,
  ) async {
    if (newQuantity < 1) return;

    final subscriptionPlan = subscription.subscriptionPlanId;
    if (subscriptionPlan == null) return;
    final updatedProducts = subscriptionPlan.productId?.map((p) {
      if (p.id == product.id) {
        return p.copyWith(quantity: newQuantity);
      }
      return p;
    }).toList();
    final newPricePerCycle = _calculatePlanPrice(updatedProducts ?? []);
    final updatedPlan = subscriptionPlan.copyWith(
      productId: updatedProducts,
      quantity: newQuantity,
      pricePerCycle: newPricePerCycle,
    );

    if (subscriptionPlan.id != null) {
      await ref
          .read(subscriptionViewModelProvider.notifier)
          .updateSubscriptionPlan(
            subscriptionPlanId: subscriptionPlan.id!,
            subscriptionPlanEntity: updatedPlan,
          );
    }
  }

  Future<void> _updateFrequency(
    SubscriptionEntity subscription,
    int newFrequency,
  ) async {
    if (newFrequency < 1) return;

    final subscriptionPlan = subscription.subscriptionPlanId;
    if (subscriptionPlan == null) return;

    final updatedPlan = subscriptionPlan.copyWith(frequency: newFrequency);

    if (subscriptionPlan.id != null) {
      await ref
          .read(subscriptionViewModelProvider.notifier)
          .updateSubscriptionPlan(
            subscriptionPlanId: subscriptionPlan.id!,
            subscriptionPlanEntity: updatedPlan,
          );
    }
  }

  Future<void> _updateActive(
    SubscriptionEntity subscription,
    bool isActive,
  ) async {
    final subscriptionPlan = subscription.subscriptionPlanId;
    if (subscriptionPlan == null) return;

    final updatedPlan = subscriptionPlan.copyWith(active: isActive);

    if (subscriptionPlan.id != null) {
      await ref
          .read(subscriptionViewModelProvider.notifier)
          .updateSubscriptionPlan(
            subscriptionPlanId: subscriptionPlan.id!,
            subscriptionPlanEntity: updatedPlan,
          );
    }
  }

  double _calculatePlanPrice(List<SubscriptionProductInfo> products) {
    double total = 0.0;
    for (var product in products) {
      final basePrice = product.basePrice ?? 0.0;
      final quantity = product.quantity ?? 1;
      total += basePrice * quantity;
    }
    return total;
  }

  Future<void> _deleteSubscription(String subscriptionId) async {
    await ref
        .read(subscriptionViewModelProvider.notifier)
        .deleteSubscription(subscriptionId: subscriptionId);
  }

  List<Map<String, dynamic>> _getSelectedItems() {
    List<Map<String, dynamic>> allSelectedItems = [];

    for (var subscription in widget.subscriptions) {
      final subscriptionId = subscription.id ?? '';
      if (subscription.subscriptionPlanId?.productId != null &&
          _selectedItemsBySubscription[subscriptionId] != null) {
        final selectedInThisSubscription = subscription
            .subscriptionPlanId!
            .productId!
            .where(
              (product) =>
                  _selectedItemsBySubscription[subscriptionId]![product.id ??
                      ''] ??
                  false,
            )
            .map(
              (product) => {'subscription': subscription, 'product': product},
            )
            .toList();
        allSelectedItems.addAll(selectedInThisSubscription);
      }
    }

    return allSelectedItems;
  }

  Future<void> _confirmSelection() async {
    final selectedItems = _getSelectedItems();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one item to confirm'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    _createdOrderIds.clear();

    final Map<String, Set<String>> subscriptionShopMap = {};

    for (var item in selectedItems) {
      final subscription = item['subscription'] as SubscriptionEntity;
      final subscriptionId = subscription.id ?? '';
      final shopId = subscription.shopId ?? '';

      if (subscriptionId.isNotEmpty && shopId.isNotEmpty) {
        subscriptionShopMap.putIfAbsent(subscriptionId, () => {}).add(shopId);
      }
    }

    for (var entry in subscriptionShopMap.entries) {
      final subscriptionId = entry.key;
      for (var shopId in entry.value) {
        await _createOrders(subscriptionId, shopId);
      }
    }
  }

  Future<void> _createOrders(String subscriptionId, String shopId) async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();

    OrderEntity orderEntity = OrderEntity(
      shopId: ShopInfo(id: shopId),
      deliveryType: 'subscription',
      subscriptionId: subscriptionId,
      userId: userId, // ✅ Now includes userId
    );

    await ref
        .read(orderViewModelProvider.notifier)
        .createOrder(shopId: shopId, orderEntity: orderEntity);
  }

  Future<void> _createPayments(List<String> orderIds) async {
    final selectedItems = _getSelectedItems();

    final uniqueSubscriptionIds = <String>{};
    double totalPrice = 0.0;

    for (var item in selectedItems) {
      final subscription = item['subscription'] as SubscriptionEntity;
      final subscriptionId = subscription.id ?? '';
      if (subscriptionId.isNotEmpty &&
          !uniqueSubscriptionIds.contains(subscriptionId)) {
        uniqueSubscriptionIds.add(subscriptionId);
        final pricePerCycle =
            subscription.subscriptionPlanId?.pricePerCycle ?? 0.0;
        totalPrice += pricePerCycle;
      }
    }
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

    final hasSubscriptions = widget.subscriptions.isNotEmpty;
    final hasAnyItems = widget.subscriptions.any(
      (subscription) =>
          subscription.subscriptionPlanId?.productId != null &&
          subscription.subscriptionPlanId!.productId!.isNotEmpty,
    );
    ref.listen(orderViewModelProvider, (previous, next) {
      if (next.status == OrderStatus.created && next.order?.id != null) {
        // Store the created order ID
        if (!_createdOrderIds.contains(next.order!.id!)) {
          _createdOrderIds.add(next.order!.id!);
        }
        _createPayments(_createdOrderIds);
      } else if (next.status == OrderStatus.error) {
        debugPrint(next.errorMessage);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${next.errorMessage ?? "Unknown error"}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });

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
      appBar: AppBar(title: const Text('My Subscriptions'), elevation: 0),
      body: !hasSubscriptions || !hasAnyItems
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.subscriptions_outlined,
                    size: 64,
                    color:
                        appColors?.mutedText ??
                        colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No active subscriptions',
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
                SubscriptionSelectAllWidget(
                  selectAll: _globalSelectAll,
                  onToggle: _toggleGlobalSelectAll,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...widget.subscriptions.map((subscription) {
                          final subscriptionId = subscription.id ?? '';
                          final products =
                              subscription.subscriptionPlanId?.productId ?? [];

                          if (products.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.card_membership,
                                              size: 20,
                                              color:
                                                  appColors?.secondaryText ??
                                                  colorScheme.onSurface
                                                      .withValues(alpha: 0.7),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Subscription ID: ${subscriptionId.substring(0, subscriptionId.length > 8 ? 8 : subscriptionId.length)}...',
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
                                          onPressed: () => _deleteSubscription(
                                            subscriptionId,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (subscription.status != null) ...[
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 18,
                                            color:
                                                appColors?.mutedText ??
                                                colorScheme.onSurface
                                                    .withValues(alpha: 0.5),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Status: ${subscription.status}',
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
                                    if (subscription.remainingCycle !=
                                        null) ...[
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.repeat,
                                            size: 18,
                                            color:
                                                appColors?.mutedText ??
                                                colorScheme.onSurface
                                                    .withValues(alpha: 0.5),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Remaining Cycles: ${subscription.remainingCycle}',
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
                                    if (subscription.startDate != null) ...[
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 18,
                                            color:
                                                appColors?.mutedText ??
                                                colorScheme.onSurface
                                                    .withValues(alpha: 0.5),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Started: ${_formatDate(subscription.startDate!)}',
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
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final productId = product.id ?? '';
                                  final isSelected =
                                      _selectedItemsBySubscription[subscriptionId]?[productId] ??
                                      false;

                                  return SubscriptionItemCard(
                                    subscription: subscription,
                                    product: product,
                                    isSelected: isSelected,
                                    onSelectionChanged: () =>
                                        _toggleItemSelection(
                                          subscriptionId,
                                          productId,
                                        ),
                                    onQuantityChanged: (newQuantity) =>
                                        _updateQuantity(
                                          subscription,
                                          product,
                                          newQuantity,
                                        ),
                                    onFrequencyChanged: (newFrequency) =>
                                        _updateFrequency(
                                          subscription,
                                          newFrequency,
                                        ),
                                    onActiveChanged: (isActive) =>
                                        _updateActive(subscription, isActive),
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
                        SubscriptionTotalSection(
                          totalPrice: _calculateTotalPrice(),
                        ),
                        SubscriptionConfirmButton(onPressed: _confirmSelection),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  double _calculateTotalPrice() {
    double total = 0.0;

    for (var subscription in widget.subscriptions) {
      final subscriptionId = subscription.id ?? '';
      if (subscription.subscriptionPlanId?.productId != null &&
          _selectedItemsBySubscription[subscriptionId] != null) {
        for (var product in subscription.subscriptionPlanId!.productId!) {
          if (_selectedItemsBySubscription[subscriptionId]![product.id ?? ''] ??
              false) {
            final basePrice = product.basePrice ?? 0.0;
            final quantity = product.quantity ?? 1;
            total += basePrice * quantity;
          }
        }
      }
    }

    return total;
  }
}
