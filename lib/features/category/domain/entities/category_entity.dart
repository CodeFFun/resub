import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? shopId;
  final List<String>? shopIds;
  final String? shopName;

  const CategoryEntity({
    this.id,
    this.name,
    this.description,
    this.shopId,
    this.shopIds,
    this.shopName,
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? shopId,
    List<String>? shopIds,
    String? shopName,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shopId: shopId ?? this.shopId,
      shopIds: shopIds ?? this.shopIds,
      shopName: shopName ?? this.shopName,
    );
  }

  @override
  List<Object?> get props => [id, name, description, shopId, shopIds, shopName];
}
