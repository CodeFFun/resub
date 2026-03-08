import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';

part 'product_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.productsTypeId)
class ProductHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double basePrice;

  @HiveField(4)
  final int stockQuantity;

  @HiveField(5)
  final double discount;

  @HiveField(6)
  final List<String> shopIds;

  @HiveField(7)
  final String categoryId;

  @HiveField(8)
  final String? shopId;

  @HiveField(9)
  final List<String>? categoryIds;

  @HiveField(10)
  final List<String>? categoryNames;

  ProductHiveModel({
    this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.stockQuantity,
    required this.discount,
    required this.shopIds,
    required this.categoryId,
    this.shopId,
    this.categoryIds,
    this.categoryNames,
  });

  // From entity
  factory ProductHiveModel.fromEntity(ProductEntity entity) {
    return ProductHiveModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      basePrice: entity.basePrice,
      stockQuantity: entity.stockQuantity,
      discount: entity.discount,
      shopIds: entity.shopIds,
      categoryId: entity.categoryId,
      shopId: entity.shopId,
      categoryIds: entity.categoryIds,
      categoryNames: entity.categoryNames,
    );
  }

  // To entity
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      basePrice: basePrice,
      stockQuantity: stockQuantity,
      discount: discount,
      shopIds: shopIds,
      categoryId: categoryId,
      shopId: shopId,
      categoryIds: categoryIds,
      categoryNames: categoryNames,
    );
  }
}
