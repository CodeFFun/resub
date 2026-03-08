import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/order/data/datasources/order_item_datasource.dart';
import 'package:resub/features/order/data/models/order_item_hive_model.dart';

final orderItemLocalDatasourceProvider = Provider<IOrderItemLocalDatasource>((
  ref,
) {
  final hiveService = ref.watch(hiveServiceProvider);
  return OrderItemLocalDatasource(hiveService: hiveService);
});

class OrderItemLocalDatasource implements IOrderItemLocalDatasource {
  final HiveService _hiveService;

  OrderItemLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<OrderItemHiveModel> createOrderItem(
    OrderItemHiveModel orderItemModel,
  ) async {
    try {
      final createdOrderItem = await _hiveService.createOrderItem(
        orderItemModel,
      );
      return createdOrderItem;
    } catch (e) {
      return Future.error('Failed to create order item: $e');
    }
  }

  @override
  Future<bool> deleteOrderItem(String id) async {
    try {
      final success = await _hiveService.deleteOrderItem(id);
      return success;
    } catch (e) {
      return Future.error('Failed to delete order item: $e');
    }
  }

  @override
  Future<void> deleteAllOrderItems() async {
    return await _hiveService.deleteAllOrderItems();
  }

  @override
  Future<List<OrderItemHiveModel>> getAllOrderItems() async {
    try {
      final orderItems = _hiveService.getAllOrderItems();
      return orderItems;
    } catch (e) {
      return Future.error('Failed to fetch order items: $e');
    }
  }

  @override
  Future<OrderItemHiveModel?> getOrderItemById(String id) async {
    try {
      final orderItem = _hiveService.getOrderItemById(id);
      return orderItem;
    } catch (e) {
      return Future.error('Failed to fetch order item by id: $e');
    }
  }

  @override
  Future<List<OrderItemHiveModel>> getOrderItemsByIds(List<String> ids) async {
    try {
      final orderItems = _hiveService.getOrderItemsByIds(ids);
      return orderItems;
    } catch (e) {
      return Future.error('Failed to fetch order items by ids: $e');
    }
  }

  @override
  Future<bool> updateOrderItem(
    String id,
    OrderItemHiveModel orderItemModel,
  ) async {
    try {
      final success = await _hiveService.updateOrderItem(id, orderItemModel);
      return success;
    } catch (e) {
      return Future.error('Failed to update order item: $e');
    }
  }
}
