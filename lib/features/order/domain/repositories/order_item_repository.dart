import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';

abstract interface class IOrderItemRepository {
  Future<Either<Failure, OrderItemEntity>> createOrderItem(
    OrderItemEntity orderItemEntity,
  );
  Future<Either<Failure, OrderItemEntity>> getOrderItemById(String id);
  Future<Either<Failure, OrderItemEntity>> updateOrderItem(
    String id,
    OrderItemEntity orderItemEntity,
  );
  Future<Either<Failure, bool>> deleteOrderItem(String id);
}
