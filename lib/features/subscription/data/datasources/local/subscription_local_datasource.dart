import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/subscription/data/datasources/subscription_datasource.dart';
import 'package:resub/features/subscription/data/models/subscription_hive_model.dart';

final subscriptionLocalDatasourceProvider =
    Provider<ISubscriptionLocalDatasource>((ref) {
      final hiveService = ref.watch(hiveServiceProvider);
      return SubscriptionLocalDatasource(hiveService: hiveService);
    });

class SubscriptionLocalDatasource implements ISubscriptionLocalDatasource {
  final HiveService _hiveService;

  SubscriptionLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<SubscriptionHiveModel> createSubscription(
    SubscriptionHiveModel subscriptionModel,
  ) async {
    return await _hiveService.createSubscription(subscriptionModel);
  }

  @override
  Future<bool> deleteSubscription(String id) async {
    return await _hiveService.deleteSubscription(id);
  }

  @override
  Future<void> deleteAllSubscriptions() async {
    return await _hiveService.deleteAllSubscriptions();
  }

  @override
  Future<List<SubscriptionHiveModel>> getAllSubscriptions() async {
    return _hiveService.getAllSubscriptions();
  }

  @override
  Future<SubscriptionHiveModel?> getSubscriptionById(String id) async {
    return _hiveService.getSubscriptionById(id);
  }

  @override
  Future<List<SubscriptionHiveModel>> getSubscriptionsByShopId(
    String shopId,
  ) async {
    return _hiveService.getSubscriptionsByShopId(shopId);
  }

  @override
  Future<List<SubscriptionHiveModel>> getSubscriptionsByUserId(
    String userId,
  ) async {
    return _hiveService.getSubscriptionsByUserId(userId);
  }

  @override
  Future<bool> updateSubscription(
    String id,
    SubscriptionHiveModel subscriptionModel,
  ) async {
    return await _hiveService.updateSubscription(id, subscriptionModel);
  }
}
