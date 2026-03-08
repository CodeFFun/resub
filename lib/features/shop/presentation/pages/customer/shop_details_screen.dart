import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/core/widgets/my_snackbar.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';
import 'package:resub/features/order/presentation/state/order_state.dart';
import 'package:resub/features/order/presentation/view_models/order_view_model.dart';
import 'package:resub/features/product/presentation/state/product_state.dart';
import 'package:resub/features/product/presentation/view_models/product_view_model.dart';
import 'package:resub/features/shop/presentation/state/shop_state.dart';
import 'package:resub/features/shop/presentation/view_models/shop_view_model.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart'
    as subscription;
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:resub/features/subscription/domain/entities/product_info_entity.dart';
import 'package:resub/features/subscription/presentation/state/subscription_state.dart';
import 'package:resub/features/subscription/presentation/view_models/subscription_view_model.dart';
import '../../widgets/shop_header_card.dart';
import '../../widgets/product_list_item.dart';
import '../../../domain/entities/shop_entity.dart';
import '../../../../product/domain/entities/product_entity.dart';

class ShopDetailsScreen extends ConsumerStatefulWidget {
  final String? shopId;
  const ShopDetailsScreen({super.key, this.shopId});

  @override
  ConsumerState<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends ConsumerState<ShopDetailsScreen> {
  ShopEntity? _shop;
  List<ProductEntity> _products = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShopData();
    });
  }

  void _onHeartPressed(ProductEntity product) async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();
    final subPlan = SubscriptionPlanEntity(
      frequency: 1,
      pricePerCycle: product.basePrice * product.stockQuantity,
      productId: [
        SubscriptionProductInfo(
          id: product.id,
          name: product.name,
          quantity: product.stockQuantity,
          basePrice: product.basePrice,
        ),
      ],
      quantity: product.stockQuantity,
    );
    await ref
        .read(subscriptionViewModelProvider.notifier)
        .createSubscriptionPlan(subscriptionPlanEntity: subPlan);

    final subState = ref.read(subscriptionViewModelProvider);
    if (subState.status == SubscriptionStatus.created &&
        subState.subscriptionPlan != null) {
      final createSubPlan = subState.subscriptionPlan!;
      final sub = subscription.SubscriptionEntity(
        remainingCycle: 1,
        subscriptionPlanId: createSubPlan,
        startDate: DateTime.now(),
        shopId: _shop?.id,
        userId: userId,
      );
      await ref
          .read(subscriptionViewModelProvider.notifier)
          .createSubscription(shopId: _shop!.id!, subscriptionEntity: sub);
    }
  }

  void _onCartPressed(ProductEntity product) async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();

    final orderItem = OrderItemEntity(
      quantity: 1,
      unitPrice: product.basePrice,
      productId: ProductInfo(id: product.id, name: product.name),
    );
    await ref
        .read(orderViewModelProvider.notifier)
        .createOrderItem(orderItemEntity: orderItem);

    final orderState = ref.read(orderViewModelProvider);

    if (orderState.status == OrderStatus.created &&
        orderState.orderItem != null) {
      final createdOrderItem = orderState.orderItem!;

      final order = OrderEntity(
        orderItemsId: [createdOrderItem],
        shopId: ShopInfo(id: _shop?.id, name: _shop?.name),
        userId: userId, // ✅ Now includes userId
      );
      await ref
          .read(orderViewModelProvider.notifier)
          .createOrder(shopId: _shop!.id!, orderEntity: order);
    }
  }

  Future<void> _loadShopData() async {
    if (widget.shopId != null) {
      await ref
          .read(shopViewModelProvider.notifier)
          .getShopById(shopId: widget.shopId!);
      await ref
          .read(productViewModelProvider.notifier)
          .getProductsByShopId(shopId: widget.shopId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ShopState>(shopViewModelProvider, (previous, next) {
      if (next.status == ShopStatus.loaded && next.shop != null) {
        setState(() {
          _shop = next.shop;
        });
      }
    });
    ref.listen<ProductState>(productViewModelProvider, (previous, next) {
      if (next.status == ProductStatus.loaded && next.products != null) {
        setState(() {
          _products = next.products!;
        });
      }
    });
    ref.listen<OrderState>(orderViewModelProvider, (previous, next) {
      if (next.status == OrderStatus.created) {
        showMySnackBar(
          context: context,
          message: "Product added to cart",
          color: Colors.green,
        );
      }
    });
    ref.listen<SubscriptionState>(subscriptionViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == SubscriptionStatus.created) {
        showMySnackBar(
          context: context,
          message: "Subscription created",
          color: Colors.green,
        );
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              if (_shop != null)
                SliverToBoxAdapter(child: ShopHeaderCard(shop: _shop!)),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0,
                  top: 50,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = _products[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ProductListItem(
                        product: product,
                        onLovePressed: () {
                          _onHeartPressed(product);
                        },
                        onCartPressed: () {
                          _onCartPressed(product);
                        },
                      ),
                    );
                  }, childCount: _products.length),
                ),
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
