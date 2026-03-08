import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/domain/repositories/category_repository.dart';
import 'package:resub/features/category/domain/usecases/get_categories_by_shop_usecase.dart';

class _FakeCategoryRepository implements ICategoryRepository {
  String? capturedShopId;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllProductCategoriesByShopId(
    String shopId,
  ) async {
    capturedShopId = shopId;
    return const Right([CategoryEntity(id: 'c1', shopId: 'shop-1')]);
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
  Future<Either<Failure, List<CategoryEntity>>> getAllShopCategories() async =>
      throw UnimplementedError();

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
  test(
    'calls repository getAllProductCategoriesByShopId with shop id',
    () async {
      final repository = _FakeCategoryRepository();
      final usecase = GetProductCategoriesByShopIdUsecase(
        categoryRepository: repository,
      );

      final result = await usecase(
        const GetProductCategoriesByShopIdUsecaseParams(shopId: 'shop-1'),
      );

      expect(repository.capturedShopId, 'shop-1');
      expect(result.isRight(), isTrue);
    },
  );
}
