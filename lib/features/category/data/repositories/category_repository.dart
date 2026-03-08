import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/category/data/datasources/category_datasource.dart';
import 'package:resub/features/category/data/datasources/local/product_category_local_datasource.dart';
import 'package:resub/features/category/data/datasources/local/shop_category_local_datasource.dart';
import 'package:resub/features/category/data/datasources/remote/category_remote_datasource.dart';
import 'package:resub/features/category/data/models/category_model.dart';
import 'package:resub/features/category/data/models/product_category_hive_model.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/domain/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  final categoryRemoteDatasource = ref.read(categoryRemoteDatasourceProvider);
  final productCategoryLocalDatasource = ref.read(
    productCategoryLocalDatasourceProvider,
  );
  final shopCategoryLocalDatasource = ref.read(
    shopCategoryLocalDatasourceProvider,
  );
  final networkInfo = ref.read(networkInfoProvider);
  return CategoryRepository(
    categoryRemoteDatasource: categoryRemoteDatasource,
    productCategoryLocalDatasource: productCategoryLocalDatasource,
    shopCategoryLocalDatasource: shopCategoryLocalDatasource,
    networkInfo: networkInfo,
  );
});

class CategoryRepository implements ICategoryRepository {
  final NetworkInfo _networkInfo;
  final ICategoryRemoteDatasource _categoryRemoteDatasource;
  final IProductCategoryLocalDatasource _productCategoryLocalDatasource;
  final IShopCategoryLocalDatasource _shopCategoryLocalDatasource;

  CategoryRepository({
    required NetworkInfo networkInfo,
    required ICategoryRemoteDatasource categoryRemoteDatasource,
    required IProductCategoryLocalDatasource productCategoryLocalDatasource,
    required IShopCategoryLocalDatasource shopCategoryLocalDatasource,
  }) : _networkInfo = networkInfo,
       _categoryRemoteDatasource = categoryRemoteDatasource,
       _productCategoryLocalDatasource = productCategoryLocalDatasource,
       _shopCategoryLocalDatasource = shopCategoryLocalDatasource;

  @override
  Future<Either<Failure, CategoryEntity>> createProductCategory(
    CategoryEntity categoryEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = CategoryApiModel.fromEntity(categoryEntity);
        final model = await _categoryRemoteDatasource.createProductCategory(
          apiModel,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = ProductCategoryHiveModel.fromEntity(categoryEntity);
        final model = await _productCategoryLocalDatasource
            .createProductCategory(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProductCategory(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _categoryRemoteDatasource.deleteProductCategory(
          id,
        );
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _productCategoryLocalDatasource
            .deleteProductCategory(id);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>>
  getAllProductCategories() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _categoryRemoteDatasource
            .getAllProductCategories();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _productCategoryLocalDatasource
            .getAllProductCategories();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllProductCategoriesByShopId(
    String shopId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _categoryRemoteDatasource
            .getAllProductCategoriesByShopId(shopId);
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _productCategoryLocalDatasource
            .getProductCategoriesByShopId(shopId);
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, CategoryEntity?>> getProductCategoryById(
    String id,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _categoryRemoteDatasource.getProductCategoryById(
          id,
        );
        return Right(model?.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _productCategoryLocalDatasource
            .getProductCategoryById(id);
        return Right(model?.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, CategoryEntity?>> updateProductCategory(
    String id,
    CategoryEntity categoryEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = CategoryApiModel.fromEntity(categoryEntity);
        final model = await _categoryRemoteDatasource.updateProductCategory(
          id,
          apiModel,
        );
        return Right(model?.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = ProductCategoryHiveModel.fromEntity(categoryEntity);
        final result = await _productCategoryLocalDatasource
            .updateProductCategory(id, hiveModel);
        if (result) {
          return Right(categoryEntity);
        } else {
          return const Left(
            LocalDatabaseFailure(message: 'Failed to update product category'),
          );
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllShopCategories() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _categoryRemoteDatasource.getAllShopCategories();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _shopCategoryLocalDatasource
            .getAllShopCategories();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
