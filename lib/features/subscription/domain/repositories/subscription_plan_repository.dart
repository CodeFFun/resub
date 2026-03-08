import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';

abstract interface class ISubscriptionPlanRepository {
  Future<Either<Failure, SubscriptionPlanEntity>> createSubscriptionPlan(
    SubscriptionPlanEntity subscriptionPlanEntity,
  );
  Future<Either<Failure, SubscriptionPlanEntity>> getSubscriptionPlanById(
    String id,
  );
  Future<Either<Failure, List<SubscriptionPlanEntity>>>
  getSubscriptionPlansByShopId(String shopId);
  Future<Either<Failure, SubscriptionPlanEntity>> updateSubscriptionPlan(
    String id,
    SubscriptionPlanEntity subscriptionPlanEntity,
  );
  Future<Either<Failure, bool>> deleteSubscriptionPlan(String id);
}
