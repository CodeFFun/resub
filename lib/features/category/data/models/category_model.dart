import 'package:resub/features/category/domain/entities/category_entity.dart';

class CategoryApiModel {
  final String? id;
  final String? name;
  final String? description;
  final String? shopId;
  final String? shopName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryApiModel({
    this.id,
    this.name,
    this.description,
    this.shopId,
    this.shopName,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    final shopData = json['shopId'];
    return CategoryApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      shopId: shopData is Map ? shopData['_id'] as String? : shopData as String?,
      shopName: shopData is Map ? shopData['name'] as String? : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (id != null) json['_id'] = id;
    if (name != null) json['name'] = name;
    if (description != null) json['description'] = description;
    if (shopId != null) json['shopId'] = shopId;
    return json;
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      description: description,
      shopId: shopId,
      shopIds: shopId != null ? [shopId!] : null,
      shopName: shopName,
    );
  }

  factory CategoryApiModel.fromEntity(CategoryEntity entity) {
    return CategoryApiModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      shopId: entity.shopId ?? entity.shopIds?.first,
    );
  }

  static List<CategoryEntity> toEntityList(List<CategoryApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
