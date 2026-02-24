import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/category/data/repositories/category_repository.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/domain/repositories/category_repository.dart';

class GetProductCategoriesByShopIdUsecaseParams extends Equatable {
  final String shopId;

  const GetProductCategoriesByShopIdUsecaseParams({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}

final getProductCategoriesByShopIdUsecaseProvider =
    Provider<GetProductCategoriesByShopIdUsecase>((ref) {
      final categoryRepository = ref.read(categoryRepositoryProvider);
      return GetProductCategoriesByShopIdUsecase(
        categoryRepository: categoryRepository,
      );
    });

class GetProductCategoriesByShopIdUsecase
    implements
        UsecaseWithParms<
          List<CategoryEntity>,
          GetProductCategoriesByShopIdUsecaseParams
        > {
  final ICategoryRepository _categoryRepository;

  GetProductCategoriesByShopIdUsecase({
    required ICategoryRepository categoryRepository,
  }) : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(
    GetProductCategoriesByShopIdUsecaseParams params,
  ) {
    return _categoryRepository.getAllProductCategoriesByShopId(params.shopId);
  }
}
