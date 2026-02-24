import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/shop/data/datasources/remote/shop_remote_datasource.dart';
import 'package:resub/features/shop/data/datasources/shop_datasource.dart';
import 'package:resub/features/shop/data/models/shop_model.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/domain/repositories/shop_repository.dart';

final shopRepositoryProvider = Provider<IShopRepository>((ref) {
  final shopRemoteDatasource = ref.read(shopRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ShopRepository(
    shopRemoteDatasource: shopRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class ShopRepository implements IShopRepository {
  final NetworkInfo _networkInfo;
  final IShopRemoteDatasource _shopRemoteDatasource;

  ShopRepository({
    required NetworkInfo networkInfo,
    required IShopRemoteDatasource shopRemoteDatasource,
  }) : _networkInfo = networkInfo,
       _shopRemoteDatasource = shopRemoteDatasource;

  @override
  Future<Either<Failure, ShopEntity>> createShop(ShopEntity shopEntity) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = ShopApiModel.fromEntity(shopEntity);
        final model = await _shopRemoteDatasource.createShop(apiModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteShop(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _shopRemoteDatasource.deleteShop(id);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ShopEntity>>> getAllShops() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _shopRemoteDatasource.getAllShops();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ShopEntity>>> getAllShopsOfAUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _shopRemoteDatasource.getAllShopsOfAUser();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ShopEntity>> getShopById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _shopRemoteDatasource.getShopById(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ShopEntity>> updateShop(
    String id,
    ShopEntity shopEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = ShopApiModel.fromEntity(shopEntity);
        final model = await _shopRemoteDatasource.updateShop(
          id,
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
}
