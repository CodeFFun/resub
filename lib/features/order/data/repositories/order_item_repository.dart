import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/order/data/datasources/local/order_item_local_datasource.dart';
import 'package:resub/features/order/data/datasources/order_item_datasource.dart';
import 'package:resub/features/order/data/datasources/remote/order_item_remote_datasource.dart';
import 'package:resub/features/order/data/models/order_item_hive_model.dart';
import 'package:resub/features/order/data/models/order_item_model.dart';
import 'package:resub/features/order/domain/entities/order_item_entity.dart';
import 'package:resub/features/order/domain/repositories/order_item_repository.dart';

final orderItemRepositoryProvider = Provider<IOrderItemRepository>((ref) {
  final orderItemRemoteDatasource = ref.read(orderItemRemoteDatasourceProvider);
  final orderItemLocalDatasource = ref.read(orderItemLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return OrderItemRepository(
    orderItemRemoteDatasource: orderItemRemoteDatasource,
    orderItemLocalDatasource: orderItemLocalDatasource,
    networkInfo: networkInfo,
  );
});

class OrderItemRepository implements IOrderItemRepository {
  final NetworkInfo _networkInfo;
  final IOrderItemRemoteDatasource _orderItemRemoteDatasource;
  final IOrderItemLocalDatasource _orderItemLocalDatasource;

  OrderItemRepository({
    required NetworkInfo networkInfo,
    required IOrderItemRemoteDatasource orderItemRemoteDatasource,
    required IOrderItemLocalDatasource orderItemLocalDatasource,
  }) : _networkInfo = networkInfo,
       _orderItemRemoteDatasource = orderItemRemoteDatasource,
       _orderItemLocalDatasource = orderItemLocalDatasource;

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
      try {
        final hiveModel = OrderItemHiveModel.fromEntity(orderItemEntity);
        final model = await _orderItemLocalDatasource.createOrderItem(
          hiveModel,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
      try {
        final result = await _orderItemLocalDatasource.deleteOrderItem(id);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
      try {
        final model = await _orderItemLocalDatasource.getOrderItemById(id);
        if (model == null) {
          return const Left(
            LocalDatabaseFailure(message: 'Order item not found'),
          );
        }
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
      try {
        final hiveModel = OrderItemHiveModel.fromEntity(orderItemEntity);
        final result = await _orderItemLocalDatasource.updateOrderItem(
          id,
          hiveModel,
        );
        if (result) {
          return Right(orderItemEntity);
        } else {
          return const Left(
            LocalDatabaseFailure(message: 'Failed to update order item'),
          );
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
