import 'package:resub/features/order/domain/entities/order_item_entity.dart';

class ProductInfoApiModel {
  final String? id;
  final String? name;
  final double? basePrice;
  final int? discount;

  ProductInfoApiModel({this.id, this.name, this.basePrice, this.discount});

  factory ProductInfoApiModel.fromJson(Map<String, dynamic> json) {
    return ProductInfoApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      basePrice: (json['base_price'] as num?)?.toDouble(),
      discount: json['discount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (name != null) json['name'] = name;
    if (basePrice != null) json['base_price'] = basePrice;
    if (discount != null) json['discount'] = discount;
    return json;
  }

  ProductInfo toEntity() {
    return ProductInfo(
      id: id,
      name: name,
      basePrice: basePrice,
      discount: discount,
    );
  }

  factory ProductInfoApiModel.fromEntity(ProductInfo entity) {
    return ProductInfoApiModel(
      id: entity.id,
      name: entity.name,
      basePrice: entity.basePrice,
      discount: entity.discount,
    );
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
    ProductInfoApiModel? productInfo;

    if (json['productId'] != null) {
      if (json['productId'] is Map<String, dynamic>) {
        productInfo = ProductInfoApiModel.fromJson(
          json['productId'] as Map<String, dynamic>,
        );
      } else if (json['productId'] is String) {
        productInfo = ProductInfoApiModel(id: json['productId'] as String?);
      }
    }

    return OrderItemApiModel(
      id: json['_id'] as String?,
      productId: productInfo,
      quantity: json['quantity'] as int?,
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (productId != null) {
      json['productId'] = productId!.id;
    }
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
