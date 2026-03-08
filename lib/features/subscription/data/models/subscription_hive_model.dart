import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/shop/data/models/shop_hive_model.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';
import 'package:resub/features/subscription/data/models/subscription_plan_hive_model.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';

part 'subscription_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.subscriptionsTypeId)
class SubscriptionHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? status;

  @HiveField(2)
  final int? remainingCycle;

  @HiveField(3)
  final String? subscriptionPlanId;

  @HiveField(4)
  final DateTime? startDate;

  @HiveField(5)
  final String? shopId;

  @HiveField(6)
  final String? userId;

  @HiveField(7)
  final String? paymentId;

  @HiveField(8)
  final DateTime? createdAt;

  @HiveField(9)
  final DateTime? updatedAt;

  // Non-persisted fields for populated relationships
  SubscriptionPlanHiveModel? _subscriptionPlan;
  ShopHiveModel? _shop;
  UserHiveModel? _user;

  SubscriptionHiveModel({
    this.id,
    this.status,
    this.remainingCycle,
    this.subscriptionPlanId,
    this.startDate,
    this.shopId,
    this.userId,
    this.paymentId,
    this.createdAt,
    this.updatedAt,
  });

  // Setters for populated relationships
  void setSubscriptionPlan(SubscriptionPlanHiveModel? plan) {
    _subscriptionPlan = plan;
  }

  void setShop(ShopHiveModel? shop) {
    _shop = shop;
  }

  void setUser(UserHiveModel? user) {
    _user = user;
  }

  // From entity
  factory SubscriptionHiveModel.fromEntity(SubscriptionEntity entity) {
    return SubscriptionHiveModel(
      id: entity.id,
      status: entity.status,
      remainingCycle: entity.remainingCycle,
      subscriptionPlanId: entity.subscriptionPlanId?.id,
      startDate: entity.startDate,
      shopId: entity.shopId,
      userId: entity.userId,
      paymentId: entity.paymentId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // To entity - returns populated objects if available
  SubscriptionEntity toEntity() {
    return SubscriptionEntity(
      id: id,
      status: status,
      remainingCycle: remainingCycle,
      subscriptionPlanId: _subscriptionPlan?.toEntity(),
      startDate: startDate,
      shopId: shopId,
      userId: userId,
      paymentId: paymentId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
