import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/subscription/data/datasources/remote/subscription_remote_datasource.dart';
import 'package:resub/features/subscription/data/datasources/subscription_datasource.dart';
import 'package:resub/features/subscription/data/models/subscription_model.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/domain/repositories/subscription_repository.dart';

final subscriptionRepositoryProvider = Provider<ISubscriptionRepository>((ref) {
  final subscriptionRemoteDatasource = ref.read(
    subscriptionRemoteDatasourceProvider,
  );
  final networkInfo = ref.read(networkInfoProvider);
  return SubscriptionRepository(
    subscriptionRemoteDatasource: subscriptionRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class SubscriptionRepository implements ISubscriptionRepository {
  final NetworkInfo _networkInfo;
  final ISubscriptionRemoteDatasource _subscriptionRemoteDatasource;

  SubscriptionRepository({
    required NetworkInfo networkInfo,
    required ISubscriptionRemoteDatasource subscriptionRemoteDatasource,
  }) : _networkInfo = networkInfo,
       _subscriptionRemoteDatasource = subscriptionRemoteDatasource;

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
      return const Left(ApiFailure(message: 'No internet connection'));
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
      return const Left(ApiFailure(message: 'No internet connection'));
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
      return const Left(ApiFailure(message: 'No internet connection'));
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
      return const Left(ApiFailure(message: 'No internet connection'));
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
      return const Left(ApiFailure(message: 'No internet connection'));
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
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }
}
