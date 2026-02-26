import 'package:resub/features/subscription/domain/entities/product_info_entity.dart';

class SubscriptionProductInfoApiModel {
  final String? name;
  final int? quantity;
  final num? basePrice;
  final String? id;

  SubscriptionProductInfoApiModel({
    this.name,
    this.quantity,
    this.basePrice,
    this.id,
  });

  factory SubscriptionProductInfoApiModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionProductInfoApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      quantity: json['quantity'] as int?,
      basePrice: json['base_price'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (name != null) json['name'] = name;
    if (quantity != null) json['quantity'] = quantity;
    if (basePrice != null) json['base_price'] = basePrice;
    return json;
  }

  SubscriptionProductInfo toEntity() {
    return SubscriptionProductInfo(
      id: id,
      name: name,
      quantity: quantity,
      basePrice: basePrice,
    );
  }

  factory SubscriptionProductInfoApiModel.fromEntity(
    SubscriptionProductInfo entity,
  ) {
    return SubscriptionProductInfoApiModel(
      name: entity.name,
      quantity: entity.quantity,
      basePrice: entity.basePrice,
      id: entity.id,
    );
  }
}
