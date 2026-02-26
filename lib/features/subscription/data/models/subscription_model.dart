import 'package:resub/features/subscription/data/models/subscription_plan_model.dart';
import 'package:resub/features/subscription/domain/entities/subscription_entity.dart';

class SubscriptionApiModel {
  final String? id;
  final String? status;
  final int? remainingCycle;
  final SubscriptionPlanApiModel? subscriptionPlanId;
  final DateTime? startDate;
  final String? shopId;
  final String? userId;
  final String? paymentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubscriptionApiModel({
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

  factory SubscriptionApiModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionApiModel(
      id: json['_id'] as String?,
      status: json['status'] as String?,
      remainingCycle: json['remaining_cycle'] as int?,
      subscriptionPlanId: json['subscription_planId'] != null
          ? SubscriptionPlanApiModel.fromJson(
              json['subscription_planId'] as Map<String, dynamic>,
            )
          : null,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : null,
      shopId: json['shopId'] as String?,
      userId: json['userId'] as String?,
      paymentId: json['paymentId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (status != null) json['status'] = status;
    if (remainingCycle != null) json['remaining_cycle'] = remainingCycle;
    if (subscriptionPlanId != null) {
      json['subscription_planId'] = subscriptionPlanId?.id;
    }
    if (startDate != null) json['start_date'] = startDate?.toIso8601String();
    if (shopId != null) json['shopId'] = shopId;
    if (userId != null) json['userId'] = userId;
    if (paymentId != null) json['paymentId'] = paymentId;
    if (createdAt != null) json['createdAt'] = createdAt?.toIso8601String();
    if (updatedAt != null) json['updatedAt'] = updatedAt?.toIso8601String();
    return json;
  }

  SubscriptionEntity toEntity() {
    return SubscriptionEntity(
      id: id,
      status: status,
      remainingCycle: remainingCycle,
      subscriptionPlanId: subscriptionPlanId?.toEntity(),
      startDate: startDate,
      shopId: shopId,
      userId: userId,
      paymentId: paymentId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory SubscriptionApiModel.fromEntity(SubscriptionEntity entity) {
    return SubscriptionApiModel(
      id: entity.id,
      status: entity.status,
      remainingCycle: entity.remainingCycle,
      subscriptionPlanId: entity.subscriptionPlanId != null
          ? SubscriptionPlanApiModel.fromEntity(entity.subscriptionPlanId!)
          : null,
      startDate: entity.startDate,
      shopId: entity.shopId,
      userId: entity.userId,
      paymentId: entity.paymentId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
