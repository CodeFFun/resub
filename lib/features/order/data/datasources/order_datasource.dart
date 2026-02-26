import 'package:resub/features/order/data/models/order_model.dart';

abstract interface class IOrderRemoteDatasource {
  Future<OrderApiModel> getOrderById(String id);
  Future<OrderApiModel> createOrder(String shopId, OrderApiModel orderModel);
  Future<List<OrderApiModel>> getOrdersByUserId();
  Future<List<OrderApiModel>> getOrdersByShopId(String shopId);
  Future<List<OrderApiModel>> getOrdersBySubscriptionId(String subscriptionId);
  Future<OrderApiModel> updateOrder(String id, OrderApiModel orderModel);
  Future<bool> deleteOrder(String id);
}
