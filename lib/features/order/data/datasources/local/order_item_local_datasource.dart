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
    return await _hiveService.createOrderItem(orderItemModel);
  }

  @override
  Future<bool> deleteOrderItem(String id) async {
    return await _hiveService.deleteOrderItem(id);
  }

  @override
  Future<void> deleteAllOrderItems() async {
    return await _hiveService.deleteAllOrderItems();
  }

  @override
  Future<List<OrderItemHiveModel>> getAllOrderItems() async {
    return _hiveService.getAllOrderItems();
  }

  @override
  Future<OrderItemHiveModel?> getOrderItemById(String id) async {
    return _hiveService.getOrderItemById(id);
  }

  @override
  Future<List<OrderItemHiveModel>> getOrderItemsByIds(List<String> ids) async {
    return _hiveService.getOrderItemsByIds(ids);
  }

  @override
  Future<bool> updateOrderItem(
    String id,
    OrderItemHiveModel orderItemModel,
  ) async {
    return await _hiveService.updateOrderItem(id, orderItemModel);
  }
}
