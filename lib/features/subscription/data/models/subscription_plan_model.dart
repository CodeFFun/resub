import 'package:resub/features/subscription/data/models/product_info_model.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';

class SubscriptionPlanApiModel {
  final String? id;
  final List<SubscriptionProductInfoApiModel>? productId;
  final num? pricePerCycle;
  final int? frequency;
  final int? quantity;
  final bool? active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubscriptionPlanApiModel({
    this.id,
    this.productId,
    this.pricePerCycle,
    this.frequency,
    this.quantity,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionPlanApiModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanApiModel(
      id: json['_id'] as String?,
      productId: (json['productId'] as List?)
          ?.map((item) {
            if (item is Map<String, dynamic>) {
              return SubscriptionProductInfoApiModel.fromJson(item);
            } else if (item is String) {
              // If backend returns just the ID string, create a model with just the ID
              return SubscriptionProductInfoApiModel(id: item);
            }
            return null;
          })
          .whereType<SubscriptionProductInfoApiModel>()
          .toList(),
      pricePerCycle: json['price_per_cycle'] as num?,
      frequency: json['frequency'] as int?,
      quantity: json['quantity'] as int?,
      active: json['active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (productId != null) {
      json['productId'] = productId?.map((p) => p.id).toList();
    }
    if (pricePerCycle != null) json['price_per_cycle'] = pricePerCycle;
    if (frequency != null) json['frequency'] = frequency;
    if (quantity != null) json['quantity'] = quantity;
    if (active != null) json['active'] = active;
    return json;
  }

  SubscriptionPlanEntity toEntity() {
    return SubscriptionPlanEntity(
      id: id,
      productId: productId?.map((p) => p.toEntity()).toList(),
      pricePerCycle: pricePerCycle,
      frequency: frequency,
      quantity: quantity,
      active: active,
    );
  }

  factory SubscriptionPlanApiModel.fromEntity(SubscriptionPlanEntity entity) {
    return SubscriptionPlanApiModel(
      id: entity.id,
      productId: entity.productId
          ?.map((p) => SubscriptionProductInfoApiModel.fromEntity(p))
          .toList(),
      pricePerCycle: entity.pricePerCycle,
      frequency: entity.frequency,
      quantity: entity.quantity,
      active: entity.active,
    );
  }
}
