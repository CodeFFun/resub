import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/category/data/repositories/category_repository.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/domain/repositories/category_repository.dart';

class UpdateProductCategoryUsecaseParams extends Equatable {
  final String categoryId;
  final CategoryEntity categoryEntity;

  const UpdateProductCategoryUsecaseParams({
    required this.categoryId,
    required this.categoryEntity,
  });

  @override
  List<Object?> get props => [categoryId, categoryEntity];
}

final updateProductCategoryUsecaseProvider =
    Provider<UpdateProductCategoryUsecase>((ref) {
      final categoryRepository = ref.read(categoryRepositoryProvider);
      return UpdateProductCategoryUsecase(
        categoryRepository: categoryRepository,
      );
    });

class UpdateProductCategoryUsecase
    implements
        UsecaseWithParms<CategoryEntity?, UpdateProductCategoryUsecaseParams> {
  final ICategoryRepository _categoryRepository;

  UpdateProductCategoryUsecase({
    required ICategoryRepository categoryRepository,
  }) : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, CategoryEntity?>> call(
    UpdateProductCategoryUsecaseParams params,
  ) {
    return _categoryRepository.updateProductCategory(
      params.categoryId,
      params.categoryEntity,
    );
  }
}
