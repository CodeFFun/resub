import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/usecases/app_usecases.dart';
import 'package:resub/features/category/data/repositories/category_repository.dart';
import 'package:resub/features/category/domain/repositories/category_repository.dart';

class DeleteProductCategoryUsecaseParams extends Equatable {
  final String categoryId;

  const DeleteProductCategoryUsecaseParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

final deleteProductCategoryUsecaseProvider =
    Provider<DeleteProductCategoryUsecase>((ref) {
      final categoryRepository = ref.read(categoryRepositoryProvider);
      return DeleteProductCategoryUsecase(
        categoryRepository: categoryRepository,
      );
    });

class DeleteProductCategoryUsecase
    implements UsecaseWithParms<bool, DeleteProductCategoryUsecaseParams> {
  final ICategoryRepository _categoryRepository;

  DeleteProductCategoryUsecase({
    required ICategoryRepository categoryRepository,
  }) : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, bool>> call(
    DeleteProductCategoryUsecaseParams params,
  ) {
    return _categoryRepository.deleteProductCategory(params.categoryId);
  }
}
