import 'package:resub/features/order/data/models/order_item_model.dart';

abstract interface class IOrderItemRemoteDatasource {
  Future<OrderItemApiModel> getOrderItemById(String id);
  Future<OrderItemApiModel> createOrderItem(OrderItemApiModel orderItemModel);
  Future<OrderItemApiModel> updateOrderItem(
    String id,
    OrderItemApiModel orderItemModel,
  );
  Future<bool> deleteOrderItem(String id);
}
