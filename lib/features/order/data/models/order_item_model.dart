import 'package:resub/features/order/domain/entities/order_item_entity.dart';

class ProductInfoApiModel {
  final String? id;
  final String? name;

  ProductInfoApiModel({this.id, this.name});

  factory ProductInfoApiModel.fromJson(Map<String, dynamic> json) {
    return ProductInfoApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (name != null) json['name'] = name;
    return json;
  }

  ProductInfo toEntity() {
    return ProductInfo(id: id, name: name);
  }

  factory ProductInfoApiModel.fromEntity(ProductInfo entity) {
    return ProductInfoApiModel(id: entity.id, name: entity.name);
  }
}

class OrderItemApiModel {
  final String? id;
  final ProductInfoApiModel? productId;
  final int? quantity;
  final double? unitPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderItemApiModel({
    this.id,
    this.productId,
    this.quantity,
    this.unitPrice,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) {
    return OrderItemApiModel(
      id: json['_id'] as String?,
      productId: json['productId'] != null
          ? ProductInfoApiModel.fromJson(
              json['productId'] as Map<String, dynamic>,
            )
          : null,
      quantity: json['quantity'] as int?,
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (productId != null) json['productId'] = productId!.toJson();
    if (quantity != null) json['quantity'] = quantity;
    if (unitPrice != null) json['unit_price'] = unitPrice;
    return json;
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id,
      productId: productId?.toEntity(),
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }

  factory OrderItemApiModel.fromEntity(OrderItemEntity entity) {
    return OrderItemApiModel(
      id: entity.id,
      productId: entity.productId != null
          ? ProductInfoApiModel.fromEntity(entity.productId!)
          : null,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
    );
  }

  static List<OrderItemEntity> toEntityList(List<OrderItemApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
