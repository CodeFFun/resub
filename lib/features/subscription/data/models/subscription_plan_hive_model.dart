import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';

part 'subscription_plan_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.subscriptionPlansTypeId)
class SubscriptionPlanHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final List<String>? productIds;

  @HiveField(2)
  final List<String>? productNames;

  @HiveField(3)
  final List<int>? productQuantities;

  @HiveField(4)
  final List<num>? productBasePrices;

  @HiveField(5)
  final List<int>? productDiscounts;

  @HiveField(6)
  final num? pricePerCycle;

  @HiveField(7)
  final int? frequency;

  @HiveField(8)
  final int? quantity;

  @HiveField(9)
  final bool? active;

  @HiveField(10)
  final DateTime? createdAt;

  @HiveField(11)
  final DateTime? updatedAt;

  SubscriptionPlanHiveModel({
    this.id,
    this.productIds,
    this.productNames,
    this.productQuantities,
    this.productBasePrices,
    this.productDiscounts,
    this.pricePerCycle,
    this.frequency,
    this.quantity,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  // From entity
  factory SubscriptionPlanHiveModel.fromEntity(SubscriptionPlanEntity entity) {
    return SubscriptionPlanHiveModel(
      id: entity.id,
      productIds: entity.productId
          ?.map((p) => p.id ?? '')
          .where((id) => id.isNotEmpty)
          .toList(),
      productNames: entity.productId
          ?.map((p) => p.name ?? '')
          .where((name) => name.isNotEmpty)
          .toList(),
      productQuantities: entity.productId?.map((p) => p.quantity ?? 0).toList(),
      productBasePrices: entity.productId
          ?.map((p) => p.basePrice ?? 0)
          .toList(),
      productDiscounts: entity.productId?.map((p) => p.discount ?? 0).toList(),
      pricePerCycle: entity.pricePerCycle,
      frequency: entity.frequency,
      quantity: entity.quantity,
      active: entity.active,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // To entity
  SubscriptionPlanEntity toEntity() {
    return SubscriptionPlanEntity(
      id: id,
      productId: null, // Products should be fetched separately
      pricePerCycle: pricePerCycle,
      frequency: frequency,
      quantity: quantity,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
