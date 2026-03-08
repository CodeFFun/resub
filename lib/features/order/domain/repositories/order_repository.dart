import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';

abstract interface class IOrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder(
    String shopId,
    OrderEntity orderEntity,
  );
  Future<Either<Failure, OrderEntity>> getOrderById(String id);
  Future<Either<Failure, List<OrderEntity>>> getOrdersByUserId();
  Future<Either<Failure, List<OrderEntity>>> getOrdersByShopId(String shopId);
  Future<Either<Failure, List<OrderEntity>>> getOrdersBySubscriptionId(
    String subscriptionId,
  );
  Future<Either<Failure, OrderEntity>> updateOrder(
    String id,
    OrderEntity orderEntity,
  );
  Future<Either<Failure, bool>> deleteOrder(String id);
}
