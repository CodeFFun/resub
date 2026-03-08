import 'package:resub/features/subscription/data/models/subscription_plan_model.dart';
import 'package:resub/features/subscription/data/models/subscription_plan_hive_model.dart';

// Remote Datasource Interface
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

// Local Datasource Interface
abstract interface class ISubscriptionPlanLocalDatasource {
  Future<SubscriptionPlanHiveModel> createSubscriptionPlan(
    SubscriptionPlanHiveModel subscriptionPlanModel,
  );
  Future<SubscriptionPlanHiveModel?> getSubscriptionPlanById(String id);
  Future<List<SubscriptionPlanHiveModel>> getAllSubscriptionPlans();
  Future<List<SubscriptionPlanHiveModel>> getSubscriptionPlansByShopId(
    String shopId,
  );
  Future<bool> updateSubscriptionPlan(
    String id,
    SubscriptionPlanHiveModel subscriptionPlanModel,
  );
  Future<bool> deleteSubscriptionPlan(String id);
  Future<void> deleteAllSubscriptionPlans();
}
