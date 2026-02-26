import 'package:resub/features/subscription/data/models/subscription_plan_model.dart';

abstract interface class ISubscriptionPlanRemoteDatasource {
  Future<SubscriptionPlanApiModel> createSubscriptionPlan(
    SubscriptionPlanApiModel subscriptionPlanApiModel,
  );
  Future<SubscriptionPlanApiModel> getSubscriptionPlanById(String id);
  Future<List<SubscriptionPlanApiModel>> getSubscriptionPlansByShopId(
    String shopId,
  );
  Future<SubscriptionPlanApiModel> updateSubscriptionPlan(
    String id,
    SubscriptionPlanApiModel subscriptionPlanApiModel,
  );
  Future<bool> deleteSubscriptionPlan(String id);
}
