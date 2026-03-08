import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/order/data/datasources/order_datasource.dart';
import 'package:resub/features/order/data/models/order_hive_model.dart';

final orderLocalDatasourceProvider = Provider<IOrderLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return OrderLocalDatasource(hiveService: hiveService);
});

class OrderLocalDatasource implements IOrderLocalDatasource {
  final HiveService _hiveService;

  OrderLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<OrderHiveModel> createOrder(OrderHiveModel orderModel) async {
    try {
      final createdOrder = await _hiveService.createOrder(orderModel);
      return createdOrder;
    } catch (e) {
      return Future.error('Failed to create order: $e');
    }
  }

  @override
  Future<bool> deleteOrder(String id) async {
    try {
      final result = await _hiveService.deleteOrder(id);
      return result;
    } catch (e) {
      return Future.error('Failed to delete order');
    }
  }

  @override
  Future<void> deleteAllOrders() async {
    return await _hiveService.deleteAllOrders();
  }

  @override
  Future<List<OrderHiveModel>> getAllOrders() async {
    try {
      final orders = _hiveService.getAllOrders();
      final populated = _populateOrderItemsForModels(orders);
      return populated;
    } catch (e) {
      return Future.error('Failed to fetch orders');
    }
  }

  @override
  Future<OrderHiveModel?> getOrderById(String id) async {
    try {
      final order = _hiveService.getOrderById(id);
      if (order != null) {
        return _populateOrderItemsForModel(order);
      }
      return null;
    } catch (e) {
      return Future.error('Failed to fetch order');
    }
  }

  @override
  Future<List<OrderHiveModel>> getOrdersByShopId(String shopId) async {
    try {
      final orders = _hiveService.getOrdersByShopId(shopId);
      final populated = _populateOrderItemsForModels(orders);
      return populated;
    } catch (e) {
      return Future.error('Failed to fetch orders by shop ID');
    }
  }

  // Helper to ensure order items are populated
  List<OrderHiveModel> _populateOrderItemsForModels(
    List<OrderHiveModel> orders,
  ) {
    return orders.map((order) => _populateOrderItemsForModel(order)).toList();
  }

  OrderHiveModel _populateOrderItemsForModel(OrderHiveModel order) {
    if (order.orderItemsIds != null && order.orderItemsIds!.isNotEmpty) {
      final items = _hiveService.getOrderItemsByIds(order.orderItemsIds!);
      if (items.isNotEmpty) {
        order.setOrderItems(items);
      }
    }
    if (order.subscriptionId != null) {
      final subscription = _hiveService.getSubscriptionById(
        order.subscriptionId!,
      );
      if (subscription != null) {
        order.setSubscription(subscription);
      }
    }
    return order;
  }

  @override
  Future<List<OrderHiveModel>> getOrdersByUserId(String userId) async {
    try {
      final orders = _hiveService.getOrdersByUserId(userId);
      return _populateOrderItemsForModels(orders);
    } catch (e) {
      return Future.error('Failed to fetch orders by user ID');
    }
  }

  @override
  Future<bool> updateOrder(String id, OrderHiveModel orderModel) async {
    try {
      final result = await _hiveService.updateOrder(id, orderModel);
      return result;
    } catch (e) {
      return Future.error('Failed to update order');
    }
  }
}
