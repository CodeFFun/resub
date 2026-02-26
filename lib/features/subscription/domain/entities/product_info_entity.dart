import 'package:equatable/equatable.dart';

class SubscriptionProductInfo extends Equatable {
  final String? id;
  final String? name;
  final int? quantity;
  final num? basePrice;

  const SubscriptionProductInfo({
    this.id,
    this.name,
    this.quantity,
    this.basePrice,
  });

  SubscriptionProductInfo copyWith({
    String? id,
    String? name,
    int? quantity,
    num? basePrice,
  }) {
    return SubscriptionProductInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      basePrice: basePrice ?? this.basePrice,
    );
  }

  @override
  List<Object?> get props => [id, name, quantity, basePrice];
}
