import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/product/data/repositories/product_repository.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/domain/repositories/product_repository.dart';

class GetProductsByShopIdUsecaseParams extends Equatable {
  final String shopId;

  const GetProductsByShopIdUsecaseParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final getProductsByShopIdUsecaseProvider = Provider<GetProductsByShopIdUsecase>(
  (ref) {
    final productRepository = ref.read(productRepositoryProvider);
    return GetProductsByShopIdUsecase(productRepository: productRepository);
  },
);

class GetProductsByShopIdUsecase
    implements
        UsecaseWithParms<
          List<ProductEntity>,
          GetProductsByShopIdUsecaseParams
        > {
  final IProductRepository _productRepository;

  GetProductsByShopIdUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetProductsByShopIdUsecaseParams params,
  ) {
    return _productRepository.getProductsByShopId(params.shopId);
  }
}
