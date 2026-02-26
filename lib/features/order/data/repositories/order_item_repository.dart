import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/order/data/datasources/order_item_datasource.dart';
import 'package:resub/features/order/data/datasources/remote/order_item_remote_datasource.dart';
import 'package:resub/features/order/data/models/order_item_model.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';
import 'package:resub/features/order/domain/repositories/order_item_repository.dart';

final orderItemRepositoryProvider = Provider<IOrderItemRepository>((ref) {
  final orderItemRemoteDatasource = ref.read(orderItemRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return OrderItemRepository(
    orderItemRemoteDatasource: orderItemRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class OrderItemRepository implements IOrderItemRepository {
  final NetworkInfo _networkInfo;
  final IOrderItemRemoteDatasource _orderItemRemoteDatasource;

  OrderItemRepository({
    required NetworkInfo networkInfo,
    required IOrderItemRemoteDatasource orderItemRemoteDatasource,
  }) : _networkInfo = networkInfo,
       _orderItemRemoteDatasource = orderItemRemoteDatasource;

  @override
  Future<Either<Failure, OrderItemEntity>> createOrderItem(
    OrderItemEntity orderItemEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = OrderItemApiModel.fromEntity(orderItemEntity);
        final model = await _orderItemRemoteDatasource.createOrderItem(
          apiModel,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteOrderItem(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _orderItemRemoteDatasource.deleteOrderItem(id);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderItemEntity>> getOrderItemById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _orderItemRemoteDatasource.getOrderItemById(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderItemEntity>> updateOrderItem(
    String id,
    OrderItemEntity orderItemEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = OrderItemApiModel.fromEntity(orderItemEntity);
        final model = await _orderItemRemoteDatasource.updateOrderItem(
          id,
          apiModel,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }
}
