import 'package:equatable/equatable.dart';
import 'package:resub/features/subscription/domain/entities/product_info_entity.dart';

class SubscriptionPlanEntity extends Equatable {
  final String? id;
  final List<SubscriptionProductInfo>? productId;
  final num? pricePerCycle;
  final int? frequency;
  final int? quantity;
  final bool? active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubscriptionPlanEntity({
    this.id,
    this.productId,
    this.pricePerCycle,
    this.frequency,
    this.quantity,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  SubscriptionPlanEntity copyWith({
    String? id,
    List<SubscriptionProductInfo>? productId,
    num? pricePerCycle,
    int? frequency,
    int? quantity,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionPlanEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      pricePerCycle: pricePerCycle ?? this.pricePerCycle,
      frequency: frequency ?? this.frequency,
      quantity: quantity ?? this.quantity,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    pricePerCycle,
    frequency,
    quantity,
    active,
    createdAt,
    updatedAt,
  ];
}
