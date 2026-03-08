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
    try {
      final createdSubscription = await _hiveService.createSubscription(
        subscriptionModel,
      );
      return createdSubscription;
    } catch (e) {
      return Future.error('Failed to create subscription: $e');
    }
  }

  @override
  Future<bool> deleteSubscription(String id) async {
    try {
      final result = await _hiveService.deleteSubscription(id);
      return result;
    } catch (e) {
      return Future.error('Failed to delete subscription');
    }
  }

  @override
  Future<void> deleteAllSubscriptions() async {
    return await _hiveService.deleteAllSubscriptions();
  }

  @override
  Future<List<SubscriptionHiveModel>> getAllSubscriptions() async {
    try {
      final subscriptions = _hiveService.getAllSubscriptions();
      return subscriptions;
    } catch (e) {
      return Future.error('Failed to fetch subscriptions');
    }
  }

  @override
  Future<SubscriptionHiveModel?> getSubscriptionById(String id) async {
    try {
      final result = _hiveService.getSubscriptionById(id);
      return Future.value(result);
    } catch (e) {
      return Future.error('Failed to fetch subscription');
    }
  }

  @override
  Future<List<SubscriptionHiveModel>> getSubscriptionsByShopId(
    String shopId,
  ) async {
    try {
      final result = _hiveService.getSubscriptionsByShopId(shopId);
      return Future.value(result);
    } catch (e) {
      return Future.error('Failed to fetch subscriptions');
    }
  }

  @override
  Future<List<SubscriptionHiveModel>> getSubscriptionsByUserId(
    String userId,
  ) async {
    try {
      final result = _hiveService.getSubscriptionsByUserId(userId);
      return Future.value(result);
    } catch (e) {
      return Future.error('Failed to fetch subscriptions');
    }
  }

  @override
  Future<bool> updateSubscription(
    String id,
    SubscriptionHiveModel subscriptionModel,
  ) async {
    try {
      final result = await _hiveService.updateSubscription(
        id,
        subscriptionModel,
      );
      return Future.value(result);
    } catch (e) {
      return Future.error('Failed to update subscription');
    }
  }
}
