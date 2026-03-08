import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/subscription/data/datasources/subscription_plan_datasource.dart';
import 'package:resub/features/subscription/data/models/subscription_plan_hive_model.dart';

final subscriptionPlanLocalDatasourceProvider =
    Provider<ISubscriptionPlanLocalDatasource>((ref) {
      final hiveService = ref.watch(hiveServiceProvider);
      return SubscriptionPlanLocalDatasource(hiveService: hiveService);
    });

class SubscriptionPlanLocalDatasource
    implements ISubscriptionPlanLocalDatasource {
  final HiveService _hiveService;

  SubscriptionPlanLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<SubscriptionPlanHiveModel> createSubscriptionPlan(
    SubscriptionPlanHiveModel subscriptionPlanModel,
  ) async {
    try {
      final createdPlan = await _hiveService.createSubscriptionPlan(subscriptionPlanModel);
      return createdPlan;
    } catch (e) {
      return Future.error('Failed to create subscription plan: $e');
    }
  }

  @override
  Future<bool> deleteSubscriptionPlan(String id) async {
    try {
      final result = await _hiveService.deleteSubscriptionPlan(id);
      return result;
    } catch (e) {
      return Future.error('Failed to delete subscription plan');
    }
  }

  @override
  Future<void> deleteAllSubscriptionPlans() async {
    return await _hiveService.deleteAllSubscriptionPlans();
  }

  @override
  Future<List<SubscriptionPlanHiveModel>> getAllSubscriptionPlans() async {
    try {
      final plans = _hiveService.getAllSubscriptionPlans();
      return plans;
    } catch (e) {
      return Future.error('Failed to fetch subscription plans');
    }
  }

  @override
  Future<List<SubscriptionPlanHiveModel>> getSubscriptionPlansByShopId(
    String shopId,
  ) async {
    try {
      final plans = _hiveService.getSubscriptionPlansByShopId(shopId);
      return plans;
    } catch (e) {
      return Future.error('Failed to fetch subscription plans by shop ID');
    }
  }

  @override
  Future<SubscriptionPlanHiveModel?> getSubscriptionPlanById(String id) async {
    try {
      final plan = _hiveService.getSubscriptionPlanById(id);
      return plan;
    } catch (e) {
      return Future.error('Failed to fetch subscription plan by ID');
    }
  }

  @override
  Future<bool> updateSubscriptionPlan(
    String id,
    SubscriptionPlanHiveModel subscriptionPlanModel,
  ) async {
    try {
      final result = await _hiveService.updateSubscriptionPlan(id, subscriptionPlanModel);
      return result;
    } catch (e) {
      return Future.error('Failed to update subscription plan');
    }
  }
}
