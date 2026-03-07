import 'package:resub/features/order/data/models/order_model.dart';
import 'package:resub/features/order/data/models/order_hive_model.dart';

// Remote Datasource Interface
abstract interface class IOrderRemoteDatasource {
  Future<OrderApiModel> getOrderById(String id);
  Future<OrderApiModel> createOrder(String shopId, OrderApiModel orderModel);
  Future<List<OrderApiModel>> getOrdersByUserId();
  Future<List<OrderApiModel>> getOrdersByShopId(String shopId);
  Future<List<OrderApiModel>> getOrdersBySubscriptionId(String subscriptionId);
  Future<OrderApiModel> updateOrder(String id, OrderApiModel orderModel);
  Future<bool> deleteOrder(String id);
}

// Local Datasource Interface
abstract interface class IOrderLocalDatasource {
  Future<OrderHiveModel> createOrder(OrderHiveModel orderModel);
  Future<OrderHiveModel?> getOrderById(String id);
  Future<List<OrderHiveModel>> getAllOrders();
  Future<List<OrderHiveModel>> getOrdersByUserId(String userId);
  Future<List<OrderHiveModel>> getOrdersByShopId(String shopId);
  Future<bool> updateOrder(String id, OrderHiveModel orderModel);
  Future<bool> deleteOrder(String id);
  Future<void> deleteAllOrders();
}
