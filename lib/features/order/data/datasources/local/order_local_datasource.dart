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
    return await _hiveService.createOrder(orderModel);
  }

  @override
  Future<bool> deleteOrder(String id) async {
    return await _hiveService.deleteOrder(id);
  }

  @override
  Future<void> deleteAllOrders() async {
    return await _hiveService.deleteAllOrders();
  }

  @override
  Future<List<OrderHiveModel>> getAllOrders() async {
    return _hiveService.getAllOrders();
  }

  @override
  Future<OrderHiveModel?> getOrderById(String id) async {
    return _hiveService.getOrderById(id);
  }

  @override
  Future<List<OrderHiveModel>> getOrdersByShopId(String shopId) async {
    return _hiveService.getOrdersByShopId(shopId);
  }

  @override
  Future<List<OrderHiveModel>> getOrdersByUserId(String userId) async {
    return _hiveService.getOrdersByUserId(userId);
  }

  @override
  Future<bool> updateOrder(String id, OrderHiveModel orderModel) async {
    return await _hiveService.updateOrder(id, orderModel);
  }
}
