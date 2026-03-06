import 'package:equatable/equatable.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';

enum ProductStatus {
  initial,
  loading,
  created,
  updated,
  deleted,
  error,
  loaded,
}

class ProductState extends Equatable {
  final ProductStatus? status;
  final ProductEntity? product;
  final List<ProductEntity>? products;
  final String? errorMessage;

  const ProductState({
    this.status,
    this.product,
    this.products,
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    ProductEntity? product,
    List<ProductEntity>? products,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      product: product ?? this.product,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, product, products, errorMessage];
}
