import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/order/data/datasources/local/order_local_datasource.dart';
import 'package:resub/features/order/data/datasources/order_datasource.dart';
import 'package:resub/features/order/data/datasources/remote/order_remote_datasource.dart';
import 'package:resub/features/order/data/models/order_hive_model.dart';
import 'package:resub/features/order/data/models/order_model.dart';
import 'package:resub/features/order/domain/entities/order_entity.dart';
import 'package:resub/features/order/domain/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<IOrderRepository>((ref) {
  final orderRemoteDatasource = ref.read(orderRemoteDatasourceProvider);
  final orderLocalDatasource = ref.read(orderLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final userSession = ref.read(userSessionServiceProvider);
  return OrderRepository(
    orderRemoteDatasource: orderRemoteDatasource,
    orderLocalDatasource: orderLocalDatasource,
    networkInfo: networkInfo,
    userSession: userSession,
  );
});

class OrderRepository implements IOrderRepository {
  final NetworkInfo _networkInfo;
  final IOrderRemoteDatasource _orderRemoteDatasource;
  final IOrderLocalDatasource _orderLocalDatasource;
  final UserSessionService _userSession;

  OrderRepository({
    required NetworkInfo networkInfo,
    required IOrderRemoteDatasource orderRemoteDatasource,
    required IOrderLocalDatasource orderLocalDatasource,
    required UserSessionService userSession,
  }) : _networkInfo = networkInfo,
       _orderRemoteDatasource = orderRemoteDatasource,
       _orderLocalDatasource = orderLocalDatasource,
       _userSession = userSession;

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
        // Sync to local
        final hiveModel = OrderHiveModel.fromEntity(model.toEntity());
        await _orderLocalDatasource.createOrder(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = OrderHiveModel.fromEntity(orderEntity);
        final model = await _orderLocalDatasource.createOrder(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteOrder(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _orderRemoteDatasource.deleteOrder(id);
        // Sync to local
        await _orderLocalDatasource.deleteOrder(id);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _orderLocalDatasource.deleteOrder(id);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _orderRemoteDatasource.getOrderById(id);
        // Sync to local
        final hiveModel = OrderHiveModel.fromEntity(model.toEntity());
        await _orderLocalDatasource.createOrder(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _orderLocalDatasource.getOrderById(id);
        if (model == null) {
          return const Left(LocalDatabaseFailure(message: 'Order not found'));
        }
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByUserId() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _orderRemoteDatasource.getOrdersByUserId();
        // Sync to local
        for (final model in models) {
          final hiveModel = OrderHiveModel.fromEntity(model.toEntity());
          await _orderLocalDatasource.createOrder(hiveModel);
        }
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final userId = _userSession.getCurrentUserId();
        if (userId == null) {
          return const Left(ApiFailure(message: 'User not logged in'));
        }
        final models = await _orderLocalDatasource.getOrdersByUserId(userId);
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByShopId(
    String shopId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _orderRemoteDatasource.getOrdersByShopId(shopId);
        // Sync to local
        for (final model in models) {
          final hiveModel = OrderHiveModel.fromEntity(model.toEntity());
          await _orderLocalDatasource.createOrder(hiveModel);
        }
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _orderLocalDatasource.getOrdersByShopId(shopId);
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
        // Sync to local
        for (final model in models) {
          final hiveModel = OrderHiveModel.fromEntity(model.toEntity());
          await _orderLocalDatasource.createOrder(hiveModel);
        }
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _orderLocalDatasource.getAllOrders();
        final filtered = models
            .where((model) => model.subscriptionId == subscriptionId)
            .toList();
        return Right(filtered.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
        // Sync to local
        final hiveModel = OrderHiveModel.fromEntity(model.toEntity());
        await _orderLocalDatasource.updateOrder(id, hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = OrderHiveModel.fromEntity(orderEntity);
        final result = await _orderLocalDatasource.updateOrder(id, hiveModel);
        if (result) {
          return Right(orderEntity);
        } else {
          return const Left(
            LocalDatabaseFailure(message: 'Failed to update order'),
          );
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
