import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/product/data/repositories/product_repository.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/domain/repositories/product_repository.dart';

class GetProductByIdUsecaseParams extends Equatable {
  final String productId;

  const GetProductByIdUsecaseParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}

final getProductByIdUsecaseProvider = Provider<GetProductByIdUsecase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return GetProductByIdUsecase(productRepository: productRepository);
});

class GetProductByIdUsecase
    implements UsecaseWithParms<ProductEntity?, GetProductByIdUsecaseParams> {
  final IProductRepository _productRepository;

  GetProductByIdUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, ProductEntity?>> call(
    GetProductByIdUsecaseParams params,
  ) {
    return _productRepository.getProductById(params.productId);
  }
}
