import 'package:equatable/equatable.dart';

class ProductInfo extends Equatable {
  final String? id;
  final String? name;

  const ProductInfo({this.id, this.name});

  ProductInfo copyWith({String? id, String? name}) {
    return ProductInfo(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [id, name];
}

class OrderItemEntity extends Equatable {
  final String? id;
  final ProductInfo? productId;
  final int? quantity;
  final double? unitPrice;

  const OrderItemEntity({
    this.id,
    this.productId,
    this.quantity,
    this.unitPrice,
  });

  OrderItemEntity copyWith({
    String? id,
    ProductInfo? productId,
    int? quantity,
    double? unitPrice,
  }) {
    return OrderItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  List<Object?> get props => [id, productId, quantity, unitPrice];
}
