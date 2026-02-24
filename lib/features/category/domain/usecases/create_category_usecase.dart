import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/category/data/repositories/category_repository.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/domain/repositories/category_repository.dart';

class CreateProductCategoryUsecaseParams extends Equatable {
  final CategoryEntity categoryEntity;

  const CreateProductCategoryUsecaseParams({required this.categoryEntity});

  @override
  List<Object?> get props => [categoryEntity];
}

final createProductCategoryUsecaseProvider =
    Provider<CreateProductCategoryUsecase>((ref) {
      final categoryRepository = ref.read(categoryRepositoryProvider);
      return CreateProductCategoryUsecase(
        categoryRepository: categoryRepository,
      );
    });

class CreateProductCategoryUsecase
    implements
        UsecaseWithParms<CategoryEntity, CreateProductCategoryUsecaseParams> {
  final ICategoryRepository _categoryRepository;

  CreateProductCategoryUsecase({
    required ICategoryRepository categoryRepository,
  }) : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, CategoryEntity>> call(
    CreateProductCategoryUsecaseParams params,
  ) {
    return _categoryRepository.createProductCategory(params.categoryEntity);
  }
}
