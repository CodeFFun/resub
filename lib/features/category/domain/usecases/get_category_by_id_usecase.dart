import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/category/data/repositories/category_repository.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/domain/repositories/category_repository.dart';

class GetProductCategoryByIdUsecaseParams extends Equatable {
  final String categoryId;

  const GetProductCategoryByIdUsecaseParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

final getProductCategoryByIdUsecaseProvider =
    Provider<GetProductCategoryByIdUsecase>((ref) {
      final categoryRepository = ref.read(categoryRepositoryProvider);
      return GetProductCategoryByIdUsecase(
        categoryRepository: categoryRepository,
      );
    });

class GetProductCategoryByIdUsecase
    implements
        UsecaseWithParms<CategoryEntity?, GetProductCategoryByIdUsecaseParams> {
  final ICategoryRepository _categoryRepository;

  GetProductCategoryByIdUsecase({
    required ICategoryRepository categoryRepository,
  }) : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, CategoryEntity?>> call(
    GetProductCategoryByIdUsecaseParams params,
  ) {
    return _categoryRepository.getProductCategoryById(params.categoryId);
  }
}
