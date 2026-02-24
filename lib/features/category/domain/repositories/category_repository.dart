import 'package:dartz/dartz.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';

abstract interface class ICategoryRepository {
  Future<Either<Failure, CategoryEntity>> createProductCategory(
    CategoryEntity categoryEntity,
  );
  Future<Either<Failure, CategoryEntity?>> getProductCategoryById(String id);
  Future<Either<Failure, List<CategoryEntity>>> getAllProductCategories();
  Future<Either<Failure, List<CategoryEntity>>> getAllShopCategories();
  Future<Either<Failure, List<CategoryEntity>>> getAllProductCategoriesByShopId(
    String shopId,
  );
  Future<Either<Failure, CategoryEntity?>> updateProductCategory(
    String id,
    CategoryEntity categoryEntity,
  );
  Future<Either<Failure, bool>> deleteProductCategory(String id);
}
