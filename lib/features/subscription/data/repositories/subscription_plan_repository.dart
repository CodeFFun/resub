import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/subscription/data/datasources/local/subscription_plan_local_datasource.dart';
import 'package:resub/features/subscription/data/datasources/remote/subscription_plan_remote_datasource.dart';
import 'package:resub/features/subscription/data/datasources/subscription_plan_datasource.dart';
import 'package:resub/features/subscription/data/models/subscription_plan_hive_model.dart';
import 'package:resub/features/subscription/data/models/subscription_plan_model.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_plan_repository.dart';

final subscriptionPlanRepositoryProvider =
    Provider<ISubscriptionPlanRepository>((ref) {
      final subscriptionPlanRemoteDatasource = ref.read(
        subscriptionPlanRemoteDatasourceProvider,
      );
      final subscriptionPlanLocalDatasource = ref.read(
        subscriptionPlanLocalDatasourceProvider,
      );
      final networkInfo = ref.read(networkInfoProvider);
      return SubscriptionPlanRepository(
        subscriptionPlanRemoteDatasource: subscriptionPlanRemoteDatasource,
        subscriptionPlanLocalDatasource: subscriptionPlanLocalDatasource,
        networkInfo: networkInfo,
      );
    });

class SubscriptionPlanRepository implements ISubscriptionPlanRepository {
  final NetworkInfo _networkInfo;
  final ISubscriptionPlanRemoteDatasource _subscriptionPlanRemoteDatasource;
  final ISubscriptionPlanLocalDatasource _subscriptionPlanLocalDatasource;

  SubscriptionPlanRepository({
    required NetworkInfo networkInfo,
    required ISubscriptionPlanRemoteDatasource subscriptionPlanRemoteDatasource,
    required ISubscriptionPlanLocalDatasource subscriptionPlanLocalDatasource,
  }) : _networkInfo = networkInfo,
       _subscriptionPlanRemoteDatasource = subscriptionPlanRemoteDatasource,
       _subscriptionPlanLocalDatasource = subscriptionPlanLocalDatasource;

  @override
  Future<Either<Failure, SubscriptionPlanEntity>> createSubscriptionPlan(
    SubscriptionPlanEntity subscriptionPlanEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = SubscriptionPlanApiModel.fromEntity(
          subscriptionPlanEntity,
        );
        final model = await _subscriptionPlanRemoteDatasource
            .createSubscriptionPlan(apiModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = SubscriptionPlanHiveModel.fromEntity(
          subscriptionPlanEntity,
        );
        final model = await _subscriptionPlanLocalDatasource
            .createSubscriptionPlan(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSubscriptionPlan(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _subscriptionPlanRemoteDatasource
            .deleteSubscriptionPlan(id);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _subscriptionPlanLocalDatasource
            .deleteSubscriptionPlan(id);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, SubscriptionPlanEntity>> getSubscriptionPlanById(
    String id,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _subscriptionPlanRemoteDatasource
            .getSubscriptionPlanById(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _subscriptionPlanLocalDatasource
            .getSubscriptionPlanById(id);
        if (model == null) {
          return const Left(
            LocalDatabaseFailure(message: 'Subscription plan not found'),
          );
        }
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<SubscriptionPlanEntity>>>
  getSubscriptionPlansByShopId(String shopId) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _subscriptionPlanRemoteDatasource
            .getSubscriptionPlansByShopId(shopId);
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _subscriptionPlanLocalDatasource
            .getSubscriptionPlansByShopId(shopId);
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, SubscriptionPlanEntity>> updateSubscriptionPlan(
    String id,
    SubscriptionPlanEntity subscriptionPlanEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = SubscriptionPlanApiModel.fromEntity(
          subscriptionPlanEntity,
        );
        final model = await _subscriptionPlanRemoteDatasource
            .updateSubscriptionPlan(id, apiModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = SubscriptionPlanHiveModel.fromEntity(
          subscriptionPlanEntity,
        );
        final result = await _subscriptionPlanLocalDatasource
            .updateSubscriptionPlan(id, hiveModel);
        if (result) {
          return Right(subscriptionPlanEntity);
        } else {
          return const Left(
            LocalDatabaseFailure(message: 'Failed to update subscription plan'),
          );
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
