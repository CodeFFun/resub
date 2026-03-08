import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';

abstract interface class ISubscriptionRepository {
  Future<Either<Failure, SubscriptionEntity>> createSubscription(
    String shopId,
    SubscriptionEntity subscriptionEntity,
  );
  Future<Either<Failure, SubscriptionEntity>> getSubscriptionById(String id);
  Future<Either<Failure, List<SubscriptionEntity>>>
  getAllSubscriptionsOfAUser();
  Future<Either<Failure, List<SubscriptionEntity>>> getAllSubscriptionsOfAShop(
    String shopId,
  );
  Future<Either<Failure, SubscriptionEntity>> updateSubscription(
    String id,
    SubscriptionEntity subscriptionEntity,
  );
  Future<Either<Failure, bool>> deleteSubscription(String id);
}
