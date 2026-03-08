import 'package:resub/features/order/data/models/order_item_model.dart';
import 'package:resub/features/order/data/models/order_item_hive_model.dart';

// Remote Datasource Interface
abstract interface class IOrderItemRemoteDatasource {
  Future<OrderItemApiModel> getOrderItemById(String id);
  Future<OrderItemApiModel> createOrderItem(OrderItemApiModel orderItemModel);
  Future<OrderItemApiModel> updateOrderItem(
    String id,
    OrderItemApiModel orderItemModel,
  );
  Future<bool> deleteOrderItem(String id);
}

// Local Datasource Interface
abstract interface class IOrderItemLocalDatasource {
  Future<OrderItemHiveModel> createOrderItem(OrderItemHiveModel orderItemModel);
  Future<OrderItemHiveModel?> getOrderItemById(String id);
  Future<List<OrderItemHiveModel>> getAllOrderItems();
  Future<List<OrderItemHiveModel>> getOrderItemsByIds(List<String> ids);
  Future<bool> updateOrderItem(String id, OrderItemHiveModel orderItemModel);
  Future<bool> deleteOrderItem(String id);
  Future<void> deleteAllOrderItems();
}
