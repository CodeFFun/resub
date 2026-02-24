import 'package:resub/features/product/domain/entities/product_entity.dart';

class ProductApiModel {
  final String? id;
  final String? name;
  final String? description;
  final double? basePrice;
  final int? stockQuantity;
  final double? discount;
  final String? shopId;
  final List<String>? categoryIds;
  final List<String>? categoryNames;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductApiModel({
    this.id,
    this.name,
    this.description,
    this.basePrice,
    this.stockQuantity,
    this.discount,
    this.shopId,
    this.categoryIds,
    this.categoryNames,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    final shopData = json['shopId'];
    final categoryData = json['categoryId'];

    final parsedCategoryIds = <String>[];
    final parsedCategoryNames = <String>[];

    void addCategory(dynamic category) {
      if (category is Map) {
        final id = category['_id'] as String?;
        final name = category['name'] as String?;
        if (id != null) parsedCategoryIds.add(id);
        if (name != null) parsedCategoryNames.add(name);
      } else if (category is String) {
        parsedCategoryIds.add(category);
      }
    }

    if (categoryData is List) {
      for (final item in categoryData) {
        addCategory(item);
      }
    } else if (categoryData != null) {
      addCategory(categoryData);
    }

    final basePriceValue = json['base_price'] ?? json['basePrice'];
    final stockQuantityValue = json['stock_quantity'] ?? json['stockQuantity'];
    final discountValue = json['discount'];

    double? parsedBasePrice;
    if (basePriceValue is num) {
      parsedBasePrice = basePriceValue.toDouble();
    } else if (basePriceValue is String) {
      parsedBasePrice = double.tryParse(basePriceValue);
    }

    int? parsedStockQuantity;
    if (stockQuantityValue is num) {
      parsedStockQuantity = stockQuantityValue.toInt();
    } else if (stockQuantityValue is String) {
      parsedStockQuantity = int.tryParse(stockQuantityValue);
    }

    double? parsedDiscount;
    if (discountValue is num) {
      parsedDiscount = discountValue.toDouble();
    } else if (discountValue is String) {
      parsedDiscount = double.tryParse(discountValue);
    }

    return ProductApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      basePrice: parsedBasePrice,
      stockQuantity: parsedStockQuantity,
      discount: parsedDiscount,
      shopId: shopData is Map
          ? shopData['_id'] as String?
          : shopData as String?,
      categoryIds: parsedCategoryIds.isEmpty ? null : parsedCategoryIds,
      categoryNames: parsedCategoryNames.isEmpty ? null : parsedCategoryNames,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (name != null) json['name'] = name;
    if (description != null) json['description'] = description;
    if (basePrice != null) json['base_price'] = basePrice;
    if (stockQuantity != null) json['stock_quantity'] = stockQuantity;
    if (discount != null) json['discount'] = discount;
    if (shopId != null) json['shopId'] = shopId;
    if (categoryIds != null) json['categoryId'] = categoryIds;
    return json;
  }

  ProductEntity toEntity() {
    final resolvedShopIds = shopId != null ? [shopId!] : <String>[];
    final resolvedCategoryIds = categoryIds ?? <String>[];
    final resolvedCategoryId = resolvedCategoryIds.isNotEmpty
        ? resolvedCategoryIds.first
        : '';

    return ProductEntity(
      id: id,
      name: name ?? '',
      description: description ?? '',
      basePrice: basePrice ?? 0,
      stockQuantity: stockQuantity ?? 0,
      discount: discount ?? 0,
      shopIds: resolvedShopIds,
      categoryId: resolvedCategoryId,
      shopId: shopId,
      categoryIds: resolvedCategoryIds.isEmpty ? null : resolvedCategoryIds,
      categoryNames: categoryNames,
    );
  }

  factory ProductApiModel.fromEntity(ProductEntity entity) {
    final resolvedShopId =
        entity.shopId ??
        (entity.shopIds.isNotEmpty ? entity.shopIds.first : null);
    final resolvedCategoryIds =
        entity.categoryIds ??
        (entity.categoryId.isNotEmpty ? [entity.categoryId] : null);

    return ProductApiModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      basePrice: entity.basePrice,
      stockQuantity: entity.stockQuantity,
      discount: entity.discount,
      shopId: resolvedShopId,
      categoryIds: resolvedCategoryIds,
      categoryNames: entity.categoryNames,
    );
  }

  static List<ProductEntity> toEntityList(List<ProductApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
