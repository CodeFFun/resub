import 'package:resub/features/subscription/data/models/subscription_model.dart';
import 'package:resub/features/subscription/data/models/subscription_hive_model.dart';

// Remote Datasource Interface
abstract interface class ISubscriptionRemoteDatasource {
  Future<SubscriptionApiModel> createSubscription(
    String shopId,
    SubscriptionApiModel subscriptionApiModel,
  );
  Future<SubscriptionApiModel> getSubscriptionById(String id);
  Future<List<SubscriptionApiModel>> getAllSubscriptionsOfAUser();
  Future<List<SubscriptionApiModel>> getAllSubscriptionsOfAShop(String shopId);
  Future<SubscriptionApiModel> updateSubscription(
    String id,
    SubscriptionApiModel subscriptionApiModel,
  );
  Future<bool> deleteSubscription(String id);
}

// Local Datasource Interface
abstract interface class ISubscriptionLocalDatasource {
  Future<SubscriptionHiveModel> createSubscription(
    SubscriptionHiveModel subscriptionModel,
  );
  Future<SubscriptionHiveModel?> getSubscriptionById(String id);
  Future<List<SubscriptionHiveModel>> getAllSubscriptions();
  Future<List<SubscriptionHiveModel>> getSubscriptionsByUserId(String userId);
  Future<List<SubscriptionHiveModel>> getSubscriptionsByShopId(String shopId);
  Future<bool> updateSubscription(
    String id,
    SubscriptionHiveModel subscriptionModel,
  );
  Future<bool> deleteSubscription(String id);
  Future<void> deleteAllSubscriptions();
}
