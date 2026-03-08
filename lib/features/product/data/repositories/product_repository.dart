import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/product/data/datasources/local/product_local_datasource.dart';
import 'package:resub/features/product/data/datasources/product_datasource.dart';
import 'package:resub/features/product/data/datasources/remote/product_remote_datasource.dart';
import 'package:resub/features/product/data/models/product_hive_model.dart';
import 'package:resub/features/product/data/models/product_model.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/domain/repositories/product_repository.dart';

final productRepositoryProvider = Provider<IProductRepository>((ref) {
  final productRemoteDatasource = ref.read(productRemoteDatasourceProvider);
  final productLocalDatasource = ref.read(productLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final userSession = ref.read(userSessionServiceProvider);
  return ProductRepository(
    productRemoteDatasource: productRemoteDatasource,
    productLocalDatasource: productLocalDatasource,
    networkInfo: networkInfo,
    userSession: userSession,
  );
});

class ProductRepository implements IProductRepository {
  final NetworkInfo _networkInfo;
  final IProductRemoteDatasource _productRemoteDatasource;
  final IProductLocalDatasource _productLocalDatasource;
  final UserSessionService _userSession;

  ProductRepository({
    required NetworkInfo networkInfo,
    required IProductRemoteDatasource productRemoteDatasource,
    required IProductLocalDatasource productLocalDatasource,
    required UserSessionService userSession,
  }) : _networkInfo = networkInfo,
       _productRemoteDatasource = productRemoteDatasource,
       _productLocalDatasource = productLocalDatasource,
       _userSession = userSession;

  @override
  Future<Either<Failure, ProductEntity>> createProduct(
    String shopId,
    ProductEntity productEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = ProductApiModel.fromEntity(productEntity);
        final model = await _productRemoteDatasource.createProduct(
          shopId,
          apiModel,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = ProductHiveModel.fromEntity(productEntity);
        final model = await _productLocalDatasource.createProduct(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _productRemoteDatasource.deleteProduct(id);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _productLocalDatasource.deleteProduct(id);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ProductEntity?>> getProductById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _productRemoteDatasource.getProductById(id);
        return Right(model?.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _productLocalDatasource.getProductById(id);
        return Right(model?.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByShopId(
    String shopId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _productRemoteDatasource.getProductsByShopId(
          shopId,
        );
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _productLocalDatasource.getProductsByShopId(
          shopId,
        );
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ProductEntity?>> updateProduct(
    String id,
    ProductEntity productEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = ProductApiModel.fromEntity(productEntity);
        final model = await _productRemoteDatasource.updateProduct(
          id,
          apiModel,
        );
        return Right(model?.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = ProductHiveModel.fromEntity(productEntity);
        final result = await _productLocalDatasource.updateProduct(
          id,
          hiveModel,
        );
        if (result) {
          return Right(productEntity);
        } else {
          return const Left(
            LocalDatabaseFailure(message: 'Failed to update product'),
          );
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
