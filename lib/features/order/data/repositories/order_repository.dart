import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/order/data/datasources/order_datasource.dart';
import 'package:resub/features/order/data/datasources/remote/order_remote_datasource.dart';
import 'package:resub/features/order/data/models/order_model.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<IOrderRepository>((ref) {
  final orderRemoteDatasource = ref.read(orderRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return OrderRepository(
    orderRemoteDatasource: orderRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class OrderRepository implements IOrderRepository {
  final NetworkInfo _networkInfo;
  final IOrderRemoteDatasource _orderRemoteDatasource;

  OrderRepository({
    required NetworkInfo networkInfo,
    required IOrderRemoteDatasource orderRemoteDatasource,
  }) : _networkInfo = networkInfo,
       _orderRemoteDatasource = orderRemoteDatasource;

  @override
  Future<Either<Failure, OrderEntity>> createOrder(
    String shopId,
    OrderEntity orderEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = OrderApiModel.fromEntity(orderEntity);
        final model = await _orderRemoteDatasource.createOrder(
          shopId,
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
  Future<Either<Failure, bool>> deleteOrder(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _orderRemoteDatasource.deleteOrder(id);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _orderRemoteDatasource.getOrderById(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByUserId() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _orderRemoteDatasource.getOrdersByUserId();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByShopId(
    String shopId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _orderRemoteDatasource.getOrdersByShopId(shopId);
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersBySubscriptionId(
    String subscriptionId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _orderRemoteDatasource.getOrdersBySubscriptionId(
          subscriptionId,
        );
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrder(
    String id,
    OrderEntity orderEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = OrderApiModel.fromEntity(orderEntity);
        final model = await _orderRemoteDatasource.updateOrder(id, apiModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }
}
