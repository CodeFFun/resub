import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/product/data/datasources/product_datasource.dart';
import 'package:resub/features/product/data/datasources/remote/product_remote_datasource.dart';
import 'package:resub/features/product/data/models/product_model.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/domain/repositories/product_repository.dart';

final productRepositoryProvider = Provider<IProductRepository>((ref) {
  final productRemoteDatasource = ref.read(productRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ProductRepository(
    productRemoteDatasource: productRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class ProductRepository implements IProductRepository {
  final NetworkInfo _networkInfo;
  final IProductRemoteDatasource _productRemoteDatasource;

  ProductRepository({
    required NetworkInfo networkInfo,
    required IProductRemoteDatasource productRemoteDatasource,
  }) : _networkInfo = networkInfo,
       _productRemoteDatasource = productRemoteDatasource;

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
      return const Left(ApiFailure(message: 'No internet connection'));
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
      return const Left(ApiFailure(message: 'No internet connection'));
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
      return const Left(ApiFailure(message: 'No internet connection'));
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
      return const Left(ApiFailure(message: 'No internet connection'));
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
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }
}
