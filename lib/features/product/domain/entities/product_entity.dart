import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String name;
  final String description;
  final double basePrice;
  final int stockQuantity;
  final double discount; 
  final List<String> shopIds; 
  final String categoryId; 
  final String? shopId; 
  final List<String>? categoryIds; 
  final List<String>? categoryNames; 

  const ProductEntity({
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

  // Calculate price after discount
  double get discountedPrice {
    return basePrice * (1 - (discount / 100));
  }

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? basePrice,
    int? stockQuantity,
    double? discount,
    List<String>? shopIds,
    String? categoryId,
    String? shopId,
    List<String>? categoryIds,
    List<String>? categoryNames,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      discount: discount ?? this.discount,
      shopIds: shopIds ?? this.shopIds,
      categoryId: categoryId ?? this.categoryId,
      shopId: shopId ?? this.shopId,
      categoryIds: categoryIds ?? this.categoryIds,
      categoryNames: categoryNames ?? this.categoryNames,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    basePrice,
    stockQuantity,
    discount,
    shopIds,
    categoryId,
    shopId,
    categoryIds,
    categoryNames,
  ];
}
