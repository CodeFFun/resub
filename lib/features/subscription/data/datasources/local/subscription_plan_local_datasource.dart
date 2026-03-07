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
    return await _hiveService.createSubscriptionPlan(subscriptionPlanModel);
  }

  @override
  Future<bool> deleteSubscriptionPlan(String id) async {
    return await _hiveService.deleteSubscriptionPlan(id);
  }

  @override
  Future<void> deleteAllSubscriptionPlans() async {
    return await _hiveService.deleteAllSubscriptionPlans();
  }

  @override
  Future<List<SubscriptionPlanHiveModel>> getAllSubscriptionPlans() async {
    return _hiveService.getAllSubscriptionPlans();
  }

  @override
  Future<List<SubscriptionPlanHiveModel>> getSubscriptionPlansByShopId(
    String shopId,
  ) async {
    return _hiveService.getSubscriptionPlansByShopId(shopId);
  }

  @override
  Future<SubscriptionPlanHiveModel?> getSubscriptionPlanById(String id) async {
    return _hiveService.getSubscriptionPlanById(id);
  }

  @override
  Future<bool> updateSubscriptionPlan(
    String id,
    SubscriptionPlanHiveModel subscriptionPlanModel,
  ) async {
    return await _hiveService.updateSubscriptionPlan(id, subscriptionPlanModel);
  }
}
