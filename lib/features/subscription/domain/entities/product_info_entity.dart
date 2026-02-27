import 'package:equatable/equatable.dart';

class SubscriptionProductInfo extends Equatable {
  final String? id;
  final String? name;
  final int? quantity;
  final num? basePrice;
  final int? discount;

  const SubscriptionProductInfo({
    this.id,
    this.name,
    this.quantity,
    this.basePrice,
    this.discount,
  });

  SubscriptionProductInfo copyWith({
    String? id,
    String? name,
    int? quantity,
    num? basePrice,
    int? discount,
  }) {
    return SubscriptionProductInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      basePrice: basePrice ?? this.basePrice,
      discount: discount ?? this.discount,
    );
  }

  @override
  List<Object?> get props => [id, name, quantity, basePrice, discount];
}
