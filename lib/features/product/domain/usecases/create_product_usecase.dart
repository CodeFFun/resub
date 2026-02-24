import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/product/data/repositories/product_repository.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/domain/repositories/product_repository.dart';

class CreateProductUsecaseParams extends Equatable {
  final String shopId;
  final ProductEntity productEntity;

  const CreateProductUsecaseParams({required this.shopId, required this.productEntity});

  @override
  List<Object?> get props => [shopId, productEntity];
}

final createProductUsecaseProvider = Provider<CreateProductUsecase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return CreateProductUsecase(productRepository: productRepository);
});

class CreateProductUsecase
    implements UsecaseWithParms<ProductEntity, CreateProductUsecaseParams> {
  final IProductRepository _productRepository;

  CreateProductUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, ProductEntity>> call(
    CreateProductUsecaseParams params,
  ) {
    return _productRepository.createProduct(params.shopId, params.productEntity);
  }
}
