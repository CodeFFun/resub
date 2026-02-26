import 'package:resub/features/subscription/data/models/subscription_model.dart';

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
