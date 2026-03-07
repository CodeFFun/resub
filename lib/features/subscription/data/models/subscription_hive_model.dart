import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';

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

  // To entity
  SubscriptionEntity toEntity() {
    return SubscriptionEntity(
      id: id,
      status: status,
      remainingCycle: remainingCycle,
      subscriptionPlanId:
          null, // Subscription plan should be fetched separately
      startDate: startDate,
      shopId: shopId,
      userId: userId,
      paymentId: paymentId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
