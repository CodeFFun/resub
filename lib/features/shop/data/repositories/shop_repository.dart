import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/shop/data/datasources/local/shop_local_datasource.dart';
import 'package:resub/features/shop/data/datasources/remote/shop_remote_datasource.dart';
import 'package:resub/features/shop/data/datasources/shop_datasource.dart';
import 'package:resub/features/shop/data/models/shop_hive_model.dart';
import 'package:resub/features/shop/data/models/shop_model.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/domain/repositories/shop_repository.dart';

final shopRepositoryProvider = Provider<IShopRepository>((ref) {
  final shopRemoteDatasource = ref.read(shopRemoteDatasourceProvider);
  final shopLocalDatasource = ref.read(shopLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final userSession = ref.read(userSessionServiceProvider);
  return ShopRepository(
    shopRemoteDatasource: shopRemoteDatasource,
    shopLocalDatasource: shopLocalDatasource,
    networkInfo: networkInfo,
    userSession: userSession,
  );
});

class ShopRepository implements IShopRepository {
  final NetworkInfo _networkInfo;
  final IShopRemoteDatasource _shopRemoteDatasource;
  final IShopLocalDatasource _shopLocalDatasource;
  final UserSessionService _userSession;

  ShopRepository({
    required NetworkInfo networkInfo,
    required IShopRemoteDatasource shopRemoteDatasource,
    required IShopLocalDatasource shopLocalDatasource,
    required UserSessionService userSession,
  }) : _networkInfo = networkInfo,
       _shopRemoteDatasource = shopRemoteDatasource,
       _shopLocalDatasource = shopLocalDatasource,
       _userSession = userSession;

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
      try {
        final currentUserId = _userSession.getCurrentUserId();
        final normalizedEntity = shopEntity.userId == null
            ? shopEntity.copyWith(userId: currentUserId)
            : shopEntity;
        final hiveModel = ShopHiveModel.fromEntity(normalizedEntity);
        final model = await _shopLocalDatasource.createShop(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteShop(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _shopRemoteDatasource.deleteShop(id);
        // Sync to local
        await _shopLocalDatasource.deleteShop(id);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _shopLocalDatasource.deleteShop(id);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ShopEntity>>> getAllShops() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _shopRemoteDatasource.getAllShops();
        // Sync to local
        for (final model in models) {
          final hiveModel = ShopHiveModel.fromEntity(model.toEntity());
          await _shopLocalDatasource.createShop(hiveModel);
        }
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _shopLocalDatasource.getAllShops();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ShopEntity>>> getAllShopsOfAUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _shopRemoteDatasource.getAllShopsOfAUser();
        // Sync to local
        for (final model in models) {
          final hiveModel = ShopHiveModel.fromEntity(model.toEntity());
          await _shopLocalDatasource.createShop(hiveModel);
        }
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final userId = _userSession.getCurrentUserId();
        if (userId == null) {
          return const Left(ApiFailure(message: 'User not logged in'));
        }
        final models = await _shopLocalDatasource.getShopsByUserId(userId);
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ShopEntity>> getShopById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _shopRemoteDatasource.getShopById(id);
        // Sync to local
        final hiveModel = ShopHiveModel.fromEntity(model.toEntity());
        await _shopLocalDatasource.createShop(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _shopLocalDatasource.getShopById(id);
        if (model == null) {
          return const Left(LocalDatabaseFailure(message: 'Shop not found'));
        }
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
        final model = await _shopRemoteDatasource.updateShop(id, apiModel);
        // Sync to local
        final hiveModel = ShopHiveModel.fromEntity(model.toEntity());
        await _shopLocalDatasource.updateShop(id, hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final currentUserId = _userSession.getCurrentUserId();
        final normalizedEntity = shopEntity.userId == null
            ? shopEntity.copyWith(userId: currentUserId)
            : shopEntity;
        final hiveModel = ShopHiveModel.fromEntity(normalizedEntity);
        final result = await _shopLocalDatasource.updateShop(id, hiveModel);
        if (result) {
          return Right(normalizedEntity);
        } else {
          return const Left(
            LocalDatabaseFailure(message: 'Failed to update shop'),
          );
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
