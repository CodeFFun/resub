import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/domain/repositories/category_repository.dart';
import 'package:resub/features/category/domain/usecases/get_shop_category_usecase.dart';

class _FakeCategoryRepository implements ICategoryRepository {
  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllShopCategories() async {
    return const Right([CategoryEntity(id: 's1', name: 'Shop Category')]);
  }

  @override
  Future<Either<Failure, CategoryEntity>> createProductCategory(
    CategoryEntity categoryEntity,
  ) async => throw UnimplementedError();

  @override
  Future<Either<Failure, CategoryEntity?>> getProductCategoryById(
    String id,
  ) async => throw UnimplementedError();

  @override
  Future<Either<Failure, List<CategoryEntity>>>
  getAllProductCategories() async => throw UnimplementedError();

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
  test('returns all shop categories from repository', () async {
    final repository = _FakeCategoryRepository();
    final usecase = GetAllShopCategoriesUsecase(categoryRepository: repository);

    final result = await usecase();

    expect(result.isRight(), isTrue);
  });
}
