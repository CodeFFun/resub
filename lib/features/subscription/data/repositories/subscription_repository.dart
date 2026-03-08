import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/subscription/data/datasources/local/subscription_local_datasource.dart';
import 'package:resub/features/subscription/data/datasources/remote/subscription_remote_datasource.dart';
import 'package:resub/features/subscription/data/datasources/subscription_datasource.dart';
import 'package:resub/features/subscription/data/models/subscription_hive_model.dart';
import 'package:resub/features/subscription/data/models/subscription_model.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_repository.dart';

final subscriptionRepositoryProvider = Provider<ISubscriptionRepository>((ref) {
  final subscriptionRemoteDatasource = ref.read(
    subscriptionRemoteDatasourceProvider,
  );
  final subscriptionLocalDatasource = ref.read(
    subscriptionLocalDatasourceProvider,
  );
  final networkInfo = ref.read(networkInfoProvider);
  final userSession = ref.read(userSessionServiceProvider);
  return SubscriptionRepository(
    subscriptionRemoteDatasource: subscriptionRemoteDatasource,
    subscriptionLocalDatasource: subscriptionLocalDatasource,
    networkInfo: networkInfo,
    userSession: userSession,
  );
});

class SubscriptionRepository implements ISubscriptionRepository {
  final NetworkInfo _networkInfo;
  final ISubscriptionRemoteDatasource _subscriptionRemoteDatasource;
  final ISubscriptionLocalDatasource _subscriptionLocalDatasource;
  final UserSessionService _userSession;

  SubscriptionRepository({
    required NetworkInfo networkInfo,
    required ISubscriptionRemoteDatasource subscriptionRemoteDatasource,
    required ISubscriptionLocalDatasource subscriptionLocalDatasource,
    required UserSessionService userSession,
  }) : _networkInfo = networkInfo,
       _subscriptionRemoteDatasource = subscriptionRemoteDatasource,
       _subscriptionLocalDatasource = subscriptionLocalDatasource,
       _userSession = userSession;

  @override
  Future<Either<Failure, SubscriptionEntity>> createSubscription(
    String shopId,
    SubscriptionEntity subscriptionEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = SubscriptionApiModel.fromEntity(subscriptionEntity);
        final model = await _subscriptionRemoteDatasource.createSubscription(
          shopId,
          apiModel,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = SubscriptionHiveModel.fromEntity(subscriptionEntity);
        final model = await _subscriptionLocalDatasource.createSubscription(
          hiveModel,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSubscription(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _subscriptionRemoteDatasource.deleteSubscription(
          id,
        );
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _subscriptionLocalDatasource.deleteSubscription(
          id,
        );
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> getSubscriptionById(
    String id,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _subscriptionRemoteDatasource.getSubscriptionById(
          id,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _subscriptionLocalDatasource.getSubscriptionById(
          id,
        );
        if (model == null) {
          return const Left(
            LocalDatabaseFailure(message: 'Subscription not found'),
          );
        }
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<SubscriptionEntity>>>
  getAllSubscriptionsOfAUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _subscriptionRemoteDatasource
            .getAllSubscriptionsOfAUser();
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
        final models = await _subscriptionLocalDatasource
            .getSubscriptionsByUserId(userId);
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> getAllSubscriptionsOfAShop(
    String shopId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _subscriptionRemoteDatasource
            .getAllSubscriptionsOfAShop(shopId);
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _subscriptionLocalDatasource
            .getSubscriptionsByShopId(shopId);
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> updateSubscription(
    String id,
    SubscriptionEntity subscriptionEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = SubscriptionApiModel.fromEntity(subscriptionEntity);
        final model = await _subscriptionRemoteDatasource.updateSubscription(
          id,
          apiModel,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = SubscriptionHiveModel.fromEntity(subscriptionEntity);
        final result = await _subscriptionLocalDatasource.updateSubscription(
          id,
          hiveModel,
        );
        if (result) {
          return Right(subscriptionEntity);
        } else {
          return const Left(
            LocalDatabaseFailure(message: 'Failed to update subscription'),
          );
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
