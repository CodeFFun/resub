import 'package:equatable/equatable.dart';
import 'package:resub/features/subscription/domain/entities/subscription_plan_entity.dart';

class ShopInfo extends Equatable {
  final String? id;
  final String? name;

  const ShopInfo({this.id, this.name});

  ShopInfo copyWith({String? id, String? name}) {
    return ShopInfo(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [id, name];
}

class SubscriptionEntity extends Equatable {
  final String? id;
  final String? status;
  final int? remainingCycle;
  final SubscriptionPlanEntity? subscriptionPlanId;
  final DateTime? startDate;
  final String? shopId;
  final String? userId;
  final String? paymentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubscriptionEntity({
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

  SubscriptionEntity copyWith({
    String? id,
    String? status,
    int? remainingCycle,
    SubscriptionPlanEntity? subscriptionPlanId,
    DateTime? startDate,
    String? shopId,
    String? userId,
    String? paymentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionEntity(
      id: id ?? this.id,
      status: status ?? this.status,
      remainingCycle: remainingCycle ?? this.remainingCycle,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
      startDate: startDate ?? this.startDate,
      shopId: shopId ?? this.shopId,
      userId: userId ?? this.userId,
      paymentId: paymentId ?? this.paymentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    status,
    remainingCycle,
    subscriptionPlanId,
    startDate,
    shopId,
    userId,
    paymentId,
    createdAt,
    updatedAt,
  ];
}
