import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/domain/repositories/category_repository.dart';
import 'package:resub/features/category/domain/usecases/get_category_by_id_usecase.dart';

class _FakeCategoryRepository implements ICategoryRepository {
  String? capturedId;

  @override
  Future<Either<Failure, CategoryEntity?>> getProductCategoryById(
    String id,
  ) async {
    capturedId = id;
    return const Right(CategoryEntity(id: 'cat-1', name: 'Fruits'));
  }

  @override
  Future<Either<Failure, CategoryEntity>> createProductCategory(
    CategoryEntity categoryEntity,
  ) async => throw UnimplementedError();

  @override
  Future<Either<Failure, List<CategoryEntity>>>
  getAllProductCategories() async => throw UnimplementedError();

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllShopCategories() async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllProductCategoriesByShopId(
    String shopId,
  ) async => throw UnimplementedError();

  @override
  Future<Either<Failure, CategoryEntity?>> updateProductCategory(
    String id,
    CategoryEntity categoryEntity,
  ) async => throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> deleteProductCategory(String id) async =>
      throw UnimplementedError();
}

void main() {
  test('calls repository getProductCategoryById with category id', () async {
    final repository = _FakeCategoryRepository();
    final usecase = GetProductCategoryByIdUsecase(
      categoryRepository: repository,
    );

    final result = await usecase(
      const GetProductCategoryByIdUsecaseParams(categoryId: 'cat-1'),
    );

    expect(repository.capturedId, 'cat-1');
    expect(result.isRight(), isTrue);
  });
}
