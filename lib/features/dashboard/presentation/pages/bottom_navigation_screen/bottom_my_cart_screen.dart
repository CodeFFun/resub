import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/presentation/pages/order_page_screen.dart';
import 'package:resub/features/order/presentation/state/order_state.dart';
import 'package:resub/features/order/presentation/view_models/order_view_model.dart';

class BottomMyCartScreen extends ConsumerStatefulWidget {
  const BottomMyCartScreen({super.key});

  @override
  ConsumerState<BottomMyCartScreen> createState() => _BottomMyCartScreenState();
}

class _BottomMyCartScreenState extends ConsumerState<BottomMyCartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShopData();
    });
  }

  Future<void> _loadShopData() async {
    ref.read(orderViewModelProvider.notifier).getOrdersByUserId();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderViewModelProvider);

    // Refetch data after update or delete
    ref.listen(orderViewModelProvider, (previous, next) {
      if (next.status == OrderStatus.updated ||
          next.status == OrderStatus.deleted) {
        _loadShopData();
      }
    });

    // Show loading indicator while fetching data
    if (orderState.status == OrderStatus.loading) {
      return Scaffold(
        appBar: AppBar(title: Text('My Cart')),
        body: Center(child: CircularProgressIndicator()),
        backgroundColor: Colors.white,
      );
    }

    final orders =
        (orderState.status == OrderStatus.loaded ||
                orderState.status == OrderStatus.updated ||
                orderState.status == OrderStatus.deleted) &&
            orderState.orders != null
        ? orderState.orders!
        : <OrderEntity>[];

    return OrderPageScreen(order: orders);
  }
}
