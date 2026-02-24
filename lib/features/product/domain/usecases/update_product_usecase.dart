import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/product/data/repositories/product_repository.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/domain/repositories/product_repository.dart';

class UpdateProductUsecaseParams extends Equatable {
  final String productId;
  final ProductEntity productEntity;

  const UpdateProductUsecaseParams({
    required this.productId,
    required this.productEntity,
  });

  @override
  List<Object?> get props => [productId, productEntity];
}

final updateProductUsecaseProvider = Provider<UpdateProductUsecase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return UpdateProductUsecase(productRepository: productRepository);
});

class UpdateProductUsecase
    implements UsecaseWithParms<ProductEntity?, UpdateProductUsecaseParams> {
  final IProductRepository _productRepository;

  UpdateProductUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, ProductEntity?>> call(
    UpdateProductUsecaseParams params,
  ) {
    return _productRepository.updateProduct(
      params.productId,
      params.productEntity,
    );
  }
}
