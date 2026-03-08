import 'package:hive/hive.dart';
import 'package:resub/core/constants/hive_table_constants.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';

part 'shop_category_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.shopCategoriesTypeId)
class ShopCategoryHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? shopId;

  @HiveField(4)
  final List<String>? shopIds;

  @HiveField(5)
  final String? shopName;

  ShopCategoryHiveModel({
    this.id,
    this.name,
    this.description,
    this.shopId,
    this.shopIds,
    this.shopName,
  });

  // From entity
  factory ShopCategoryHiveModel.fromEntity(CategoryEntity entity) {
    return ShopCategoryHiveModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      shopId: entity.shopId,
      shopIds: entity.shopIds,
      shopName: entity.shopName,
    );
  }

  // To entity
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      description: description,
      shopId: shopId,
      shopIds: shopIds,
      shopName: shopName,
    );
  }
}
